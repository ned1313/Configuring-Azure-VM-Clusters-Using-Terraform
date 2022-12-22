output "app_gateway_address" {
  description = "Web address of the load balancer front end"
    value = module.name.app_gateway_address 
}