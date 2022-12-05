# Resource group for the cluster
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_subscription" "current" {}

# Network Interfaces
resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "${var.prefix}-vault-${count.index}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.prefix}NICConfg"
    subnet_id                     = var.vault_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(
    var.common_tags, var.vault_tag
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "${var.prefix}NICConfg"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

# Application Security Group
resource "azurerm_application_security_group" "main" {
  name                = "${var.prefix}-vault"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# Network security group
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-vault"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# Network security rules
resource "azurerm_network_security_rule" "vault_api" {
  name                        = "${var.prefix}-vault-api"
  description                 = "Allow Vault servers to talk to each other via API"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  destination_port_range      = 8200
  source_port_range           = "*"

  destination_application_security_group_ids = [azurerm_application_security_group.main.id]
  source_application_security_group_ids      = [azurerm_application_security_group.main.id]

}

resource "azurerm_network_security_rule" "vault_cluster" {
  name                        = "${var.prefix}-vault-cluster"
  description                 = "Allow Vault servers to talk to each other via Raft and cluster"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  destination_port_range      = 8201
  source_port_range           = "*"

  destination_application_security_group_ids = [azurerm_application_security_group.main.id]
  source_application_security_group_ids      = [azurerm_application_security_group.main.id]

}

resource "azurerm_network_security_rule" "vault_lb" {
  name                        = "${var.prefix}-vault-lb"
  description                 = "Allow LB to talk to Vault servers"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  destination_port_range      = 8200
  source_port_range           = "*"

  destination_application_security_group_ids = [azurerm_application_security_group.main.id]
  source_address_prefix                      = "${azurerm_lb.main.private_ip_address}/32"
}

resource "azurerm_network_security_rule" "vault_clients" {
  name                        = "${var.prefix}-vault-clients"
  description                 = "Allow Vault clients to talk to the LB"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  destination_port_range      = 8200
  source_port_range           = "*"

  destination_address_prefix = "${azurerm_lb.main.private_ip_address}/32"
  source_address_prefix      = "*"
}

# Security group association
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = var.vault_subnet_id
  network_security_group_id = azurerm_network_security_group.main.id
}

# User Identity

resource "azurerm_user_assigned_identity" "main" {
  location            = data.azurerm_resource_group.main.location
  name                = "${var.prefix}-vault"
  resource_group_name = data.azurerm_resource_group.main.name
}

# Role association for Microsoft.Network/networkInterfaces/*
resource "azurerm_role_definition" "main" {
  scope       = data.azurerm_subscription.current.id
  name        = "${var.prefix}-vault-auto-join"
  description = "Custom role to allow cluster auto-join"
  permissions {
    actions = [
      "Microsoft.Network/networkInterfaces/*",
    ]
    not_actions = []
  }
  assignable_scopes = [data.azurerm_subscription.current.id]
}

resource "azurerm_role_assignment" "main" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.main.name
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

# Azure VMs
resource "azurerm_linux_virtual_machine" "main" {
  count                 = var.vm_count
  admin_username        = var.admin_username
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  name                  = "${var.prefix}-vault-${count.index}"
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.main[count.index].id]
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  zone = var.zones[count.index % length(var.zones)]

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  custom_data = base64encode(templatefile("${path.module}/templates/custom_data.tpl", {
    vault_version         = var.vault_version
    vault_cert_pem        = var.vault_cert_pem
    vault_key_pem         = var.vault_key_pem
    vault_ca_pem          = var.vault_ca_pem
    vault_tag             = keys(var.vault_tag)[0]
    vault_tag_value       = values(var.vault_tag)[0]
    leader_tls_servername = var.vault_san_name
    subscription_id       = data.azurerm_subscription.current.subscription_id
    tenant_id             = data.azurerm_subscription.current.tenant_id
  }))

  tags = merge(
    var.common_tags, var.vault_tag
  )
}

# Data disk

resource "azurerm_managed_disk" "main" {
  count                = var.vm_count
  name                 = "${var.prefix}-vault-${count.index}-data"
  location             = data.azurerm_resource_group.main.location
  resource_group_name  = data.azurerm_resource_group.main.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
  zone                 = var.zones[count.index % length(var.zones)]

}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.main[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.main[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}

# Azure Load Balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-vault"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "${var.prefix}-lb-fe"
    subnet_id                     = var.vault_subnet_id
    zones                         = var.zones
    private_ip_address_allocation = "Dynamic"
  }
}

# Azure Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "VaultBEAddressPool"
}

# Azure Load Balancer Health Probe
resource "azurerm_lb_probe" "main" {
  name            = "${var.prefix}-vault"
  loadbalancer_id = azurerm_lb.main.id
  protocol        = "Https"
  port            = 8200
  request_path    = "/v1/sys/health"
}

# Azure Load Balancer Rule
resource "azurerm_lb_rule" "main" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "VaultAPI"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 8200
  frontend_ip_configuration_name = "${var.prefix}-lb-fe"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.main.id,
  ]
  probe_id = azurerm_lb_probe.main.id
}
