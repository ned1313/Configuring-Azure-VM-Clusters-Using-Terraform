app_gateway_subnet_id = "/subscriptions/4d8e572a-3214-40e9-a26f-8f71ecd24e0d/resourceGroups/nsb-nginx/providers/Microsoft.Network/virtualNetworks/nsb-nginx/subnets/nsb-gateway"
prefix                = "nsb"
location              = "eastus"
vmss_admin_username   = "nginxAdmin"
vmss_source_image = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "latest"
}
vmss_subnet_id    = "/subscriptions/4d8e572a-3214-40e9-a26f-8f71ecd24e0d/resourceGroups/nsb-nginx/providers/Microsoft.Network/virtualNetworks/nsb-nginx/subnets/nsb-web"
create_index_html = true