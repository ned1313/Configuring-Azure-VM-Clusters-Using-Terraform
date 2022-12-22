# Resource group for the cluster
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Application Gateway subnet information
data "azurerm_subnet" "app_gateway" {
  name                 = split("/", var.app_gateway_subnet_id)[10]
  virtual_network_name = split("/", var.app_gateway_subnet_id)[8]
  resource_group_name  = split("/", var.app_gateway_subnet_id)[4]
}

data "azurerm_virtual_network" "main" {
  name                = split("/", var.app_gateway_subnet_id)[8]
  resource_group_name = split("/", var.app_gateway_subnet_id)[4]
}

# Public IP address
resource "azurerm_public_ip" "app_gateway" {
  name                = "${var.prefix}-app-gateway"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
  tags                = var.common_tags
}

locals {
  frontend_port_name             = "${var.prefix}-app-gateway-frontend-port"
  frontend_ip_configuration_name = "${var.prefix}-app-gateway-frontend-ip"
  backend_address_pool_name      = "${var.prefix}-app-gateway-backend-pool"
  backend_http_setting_name      = "${var.prefix}-app-gateway-backend-http-setting"
  listener_name                  = "${var.prefix}-app-gateway-listener"
  request_routing_rule_name      = "${var.prefix}-app-gateway-request-routing-rule"
  probe_name                     = "${var.prefix}-app-gateway-probe"
}

resource "azurerm_application_gateway" "main" {
  name                = "${var.prefix}-app-gateway"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  tags                = var.common_tags

  sku {
    name     = var.app_gateway_sku      # default Standard_Small
    tier     = var.app_gateway_tier     # default Standard
    capacity = var.app_gateway_capacity # default 2
  }

  gateway_ip_configuration {
    name      = "${var.prefix}-app-gateway-ip-config"
    subnet_id = var.app_gateway_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = var.frontend_port
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = var.backend_port
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.probe_name
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  probe {
    name                = local.probe_name
    host                = "127.0.0.1"
    protocol            = "Http"
    path                = "/"
    interval            = 3
    timeout             = 3
    unhealthy_threshold = 3
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_setting_name
  }
}