data "http" "icanhazip" {
  url = "http://icanhazip.com"
}

locals {
  base_name = "${var.prefix}-proxy"
}

# Public IP Address
resource "azurerm_public_ip" "main" {
  name                = local.base_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = lower(local.base_name)
}

resource "azurerm_network_security_group" "main" {
  name                = local.base_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "app" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  name                        = "App"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "${chomp(data.http.icanhazip.response_body)}/32"
  destination_address_prefix  = "*"
}

# Network interface

resource "azurerm_network_interface" "main" {
  name                = local.base_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.prefix}NICConfg"
    subnet_id                     = var.proxy_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Linux VM with SSH enabled
resource "azurerm_linux_virtual_machine" "main" {
  name                  = local.base_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name = local.base_name
  # Copy Root CA cert to VM
  custom_data = base64encode(templatefile("${path.module}/templates/custom_data.tpl", {
    root_ca_cert = var.root_ca_cert
  }))

  tags = var.common_tags
}