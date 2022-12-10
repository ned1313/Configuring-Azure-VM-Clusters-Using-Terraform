resource "azurerm_virtual_network" "nginx" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-nginx"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags

  address_space = [
    var.address_space,
  ]
}

resource "azurerm_subnet" "nginx" {
  name                 = "${var.resource_name_prefix}-web"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.nginx.name

  address_prefixes = [
    var.nginx_address_prefix,
  ]

}

resource "azurerm_subnet" "app_gateway" {
  name                 = "${var.resource_name_prefix}-gateway"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.nginx.name

  address_prefixes = [
    var.app_gateway_address_prefix,
  ]

}

resource "azurerm_nat_gateway" "nginx" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-nginx"
  resource_group_name = var.resource_group.name
  sku_name            = "Standard"
  tags                = var.common_tags
}

resource "azurerm_public_ip" "nginx_nat" {
  allocation_method   = "Static"
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-nginx-nat"
  resource_group_name = var.resource_group.name
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "nginx" {
  nat_gateway_id       = azurerm_nat_gateway.nginx.id
  public_ip_address_id = azurerm_public_ip.nginx_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "nginx" {
  nat_gateway_id = azurerm_nat_gateway_public_ip_association.nginx.nat_gateway_id
  subnet_id      = azurerm_subnet.nginx.id
}