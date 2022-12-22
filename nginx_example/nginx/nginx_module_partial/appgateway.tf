# Resource group for the cluster
data "azurerm_resource_group" "main" {
  
}

# Application Gateway subnet information
data "azurerm_subnet" "app_gateway" {
  
}

data "azurerm_virtual_network" "main" {
  
}

# Public IP address
resource "azurerm_public_ip" "app_gateway" {
  
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
  
}