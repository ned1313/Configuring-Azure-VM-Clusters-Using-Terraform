provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "nginx" {
  count = var.resource_group == null ? 1 : 0

  location = var.location
  name     = "${var.resource_name_prefix}-nginx"
  tags     = var.common_tags
}

locals {
  resource_group = var.resource_group == null ? { location = azurerm_resource_group.nginx[0].location, name = azurerm_resource_group.nginx[0].name } : var.resource_group
}

module "vnet" {
  source = "./network"

  address_space              = var.address_space
  common_tags                = var.common_tags
  resource_group             = local.resource_group
  resource_name_prefix       = var.resource_name_prefix
  nginx_address_prefix       = var.nginx_address_prefix
  app_gateway_address_prefix = var.app_gateway_address_prefix
}