output "proxy_subnet_id" {
  value = azurerm_subnet.proxy_vm.id
}

output "vault_subnet_id" {
  value = azurerm_subnet.vault.id

  depends_on = [
    azurerm_subnet_nat_gateway_association.vault,
  ]
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vault.name
}