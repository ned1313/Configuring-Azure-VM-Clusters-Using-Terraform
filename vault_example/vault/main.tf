provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  count    = var.resource_group == null ? 1 : 0
  name     = "${var.prefix}-vault-cluster"
  location = var.location
}

resource "tls_private_key" "main" {
  count     = var.admin_public_key == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  resource_group   = var.resource_group == null ? azurerm_resource_group.main[0] : var.resource_group
  admin_public_key = var.admin_public_key == null ? tls_private_key.main[0].public_key_openssh : var.admin_public_key
  vault_tag        = var.vault_tag == null ? { vault_cluster = "${var.prefix}-vault-cluster" } : var.vault_tag
}

module "vault_cluster" {
  source = "./vault_module"

  resource_group_name = local.resource_group.name
  vm_count            = var.cluster_size
  prefix              = var.prefix
  vault_subnet_id     = var.vault_subnet_id
  admin_username      = var.admin_username
  admin_public_key    = local.admin_public_key
  zones               = var.zones
  vm_size             = var.vm_size
  vault_version       = var.vault_version
  vault_cert_pem      = var.vault_cert_pem
  vault_key_pem       = var.vault_key_pem
  vault_ca_pem        = var.vault_ca_pem
  vault_tag           = local.vault_tag
  vault_san_name      = var.vault_san_name
  data_disk_size_gb   = var.data_disk_size_gb

}