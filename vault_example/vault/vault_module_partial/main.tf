# Resource group for the cluster
data "azurerm_resource_group" "main" {
  
}

# Azure Subscription data
data "azurerm_subscription" "current" {}

# Network Interfaces
resource "azurerm_network_interface" "main" {
  

}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  
}

# Application Security Group
resource "azurerm_application_security_group" "main" {
  
}

# Network security group
resource "azurerm_network_security_group" "main" {
  
}

# Network security rules
resource "azurerm_network_security_rule" "vault_api" {
  

}

resource "azurerm_network_security_rule" "vault_cluster" {

}

resource "azurerm_network_security_rule" "vault_lb" {
  
}

resource "azurerm_network_security_rule" "vault_clients" {
  
}

# Security group association
resource "azurerm_subnet_network_security_group_association" "main" {
  
}

# User Identity

resource "azurerm_user_assigned_identity" "main" {
  
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
  

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/templates/custom_data.tpl", {
    
  }))

}

# Data disk

resource "azurerm_managed_disk" "main" {

}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  
}

# Azure Load Balancer
resource "azurerm_lb" "main" {
  
}

# Azure Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "main" {
  
}

# Azure Load Balancer Health Probe
resource "azurerm_lb_probe" "main" {
  
}

# Azure Load Balancer Rule
resource "azurerm_lb_rule" "main" {
  
}
