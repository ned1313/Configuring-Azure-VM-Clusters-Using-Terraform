output "vault_cluster_address" {
  description = "The front end IP address of the load balancer."
  value       = azurerm_lb.main.private_ip_address
}

output "vault_cluster_ip_addresses" {
  description = "The list of private IP addresses for the cluster nodes."
  value       = [for server in azurerm_linux_virtual_machine.main : server.private_ip_address]
}