provider "azurerm" {
  features {}
}

resource "tls_private_key" "main" {
  count     = var.vmss_admin_ssh_key == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_resource_group" "main" {
  count = var.resource_group == null ? 0 : 1
  name  = var.resource_group.name
}

resource "azurerm_resource_group" "main" {
  count    = var.resource_group == null ? 1 : 0
  name     = "${var.prefix}-nginx-cluster"
  location = var.location
}

locals {
  resource_group   = var.resource_group == null ? azurerm_resource_group.main[0] : data.azurerm_resource_group.main[0]
  admin_public_key = var.vmss_admin_ssh_key == null ? tls_private_key.main[0].public_key_openssh : var.vmss_admin_ssh_key
}

module "name" {
  source = "./nginx_module"

  app_gateway_subnet_id = var.app_gateway_subnet_id
  prefix                = var.prefix
  vmss_admin_username   = var.vmss_admin_username
  vmss_admin_ssh_key    = tls_private_key.main[0].public_key_openssh
  vmss_source_image     = var.vmss_source_image
  vmss_subnet_id        = var.vmss_subnet_id
  resource_group_name   = local.resource_group.name
  create_index_html     = var.create_index_html

  depends_on = [
    azurerm_resource_group.main
  ]
}