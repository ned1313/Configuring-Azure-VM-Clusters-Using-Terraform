output "resource_group" {
  value = local.resource_group
}

output "nginx_subnet_id" {
  value = module.vnet.nginx_subnet_id
}

output "app_gateway_subnet_id" {
  value = module.vnet.app_gateway_subnet_id
}

output "virtual_network_name" {
  value = module.vnet.virtual_network_name
}