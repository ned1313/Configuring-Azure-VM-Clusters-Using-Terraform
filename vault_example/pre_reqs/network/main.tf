/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags

  address_space = [
    var.address_space,
  ]
}

resource "azurerm_subnet" "vault" {
  name                 = "${var.resource_name_prefix}-vault"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vault.name

  address_prefixes = [
    var.vault_address_prefix,
  ]

}

resource "azurerm_nat_gateway" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault"
  resource_group_name = var.resource_group.name
  sku_name            = "Standard"
  tags                = var.common_tags
}

resource "azurerm_public_ip" "vault_nat" {
  allocation_method   = "Static"
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault-nat"
  resource_group_name = var.resource_group.name
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "vault" {
  nat_gateway_id       = azurerm_nat_gateway.vault.id
  public_ip_address_id = azurerm_public_ip.vault_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "vault" {
  nat_gateway_id = azurerm_nat_gateway_public_ip_association.vault.nat_gateway_id
  subnet_id      = azurerm_subnet.vault.id
}

resource "azurerm_subnet" "proxy_vm" {
  name                 = "${var.resource_name_prefix}-proxy-vm"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vault.name

  address_prefixes = [
    var.proxy_vm_address_prefix,
  ]

}