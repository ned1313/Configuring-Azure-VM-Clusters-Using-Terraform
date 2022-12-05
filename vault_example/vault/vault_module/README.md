# HashiCorp Vault Cluster Module

This Terraform module is intended to deploy a HashiCorp Vault cluster to an Azure Virtual Network.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_security_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_lb.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_security_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.vault_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.vault_clients](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.vault_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.vault_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_role_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_subnet_network_security_group_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_machine_data_disk_attachment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_public_key"></a> [admin\_public\_key](#input\_admin\_public\_key) | (Required) Public key for Vault servers. | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Required) Username for Vault servers. | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | (Optional) Tags to use for Vault servers. Defaults to empty | `map(string)` | `{}` | no |
| <a name="input_data_disk_size_gb"></a> [data\_disk\_size\_gb](#input\_data\_disk\_size\_gb) | (Required) Size of data disk in GB. | `number` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Required) Prefix to use for naming resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of resource group to use for Vault. | `string` | n/a | yes |
| <a name="input_vault_ca_pem"></a> [vault\_ca\_pem](#input\_vault\_ca\_pem) | (Required) PEM-encoded CA certificate for Vault. | `string` | n/a | yes |
| <a name="input_vault_cert_pem"></a> [vault\_cert\_pem](#input\_vault\_cert\_pem) | (Required) PEM-encoded certificate for Vault. | `string` | n/a | yes |
| <a name="input_vault_key_pem"></a> [vault\_key\_pem](#input\_vault\_key\_pem) | (Required) PEM-encoded private key for Vault. | `string` | n/a | yes |
| <a name="input_vault_san_name"></a> [vault\_san\_name](#input\_vault\_san\_name) | (Required) SAN name for Vault servers. | `string` | n/a | yes |
| <a name="input_vault_subnet_id"></a> [vault\_subnet\_id](#input\_vault\_subnet\_id) | (Required) ID of the subnet to deploy Vault servers into. | `string` | n/a | yes |
| <a name="input_vault_tag"></a> [vault\_tag](#input\_vault\_tag) | (Required) Tag to use for Vault servers. | `map(string)` | n/a | yes |
| <a name="input_vault_version"></a> [vault\_version](#input\_vault\_version) | (Required) Version of Vault to deploy. | `string` | n/a | yes |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | (Required) Number of Vault servers to deploy. Must be an odd number. | `number` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | (Required) Size of Vault servers. Must be an E-series or D-series VM. | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | (Required) List of availability zones to deploy Vault servers into. | `list(number)` | n/a | yes |

## Outputs

| Name | Description | Type |
|------|-------------|------|
| <a name="output_vault_cluster_address"></a> [vault\_cluster\_address](#output\_vault\_cluster\_address) | The front end IP address of the load balancer. | `string` |
| <a name="output_vault_cluster_ip_addresses"></a> [vault\_cluster\_ip\_addresses](#output\_vault\_cluster\_ip\_addresses) | The list of private IP addresses for the cluster nodes. | `list(string)` |
