/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "vault" {
  count = var.resource_group == null ? 1 : 0

  location = var.location
  name     = "${var.resource_name_prefix}-vault"
  tags     = var.common_tags
}

locals {
  resource_group = var.resource_group == null ? { location = azurerm_resource_group.vault[0].location, name = azurerm_resource_group.vault[0].name } : var.resource_group
}

module "vnet" {
  source = "./network"

  address_space           = var.address_space
  common_tags             = var.common_tags
  proxy_vm_address_prefix = var.proxy_vm_address_prefix
  resource_group          = local.resource_group
  resource_name_prefix    = var.resource_name_prefix
  vault_address_prefix    = var.vault_address_prefix
}

module "tls" {
  source = "./tls"

  shared_san = var.shared_san
}

module "proxy" {
  source = "./proxy"

  common_tags         = var.common_tags
  prefix              = var.resource_name_prefix
  location            = var.location
  resource_group_name = local.resource_group.name
  proxy_subnet_id     = module.vnet.proxy_subnet_id
  root_ca_cert        = module.tls.root_ca_pem
  admin_password      = var.admin_password
}