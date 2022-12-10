output "nginx_subnet_id" {
  value = azurerm_subnet.nginx.id

  depends_on = [
    azurerm_subnet_nat_gateway_association.nginx,
  ]
}

output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway.id

}

output "virtual_network_name" {
  value = azurerm_virtual_network.nginx.name
}