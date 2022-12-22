# Private link for testing
output "private_link_info" {
  value = azurerm_private_endpoint.main
}

output "app_gateway_address" {
  description = "Front end address of the application gateway"
  value = azurerm_public_ip.app_gateway.fqdn
}