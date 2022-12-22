/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

output "leader_tls_servername" {
  value = module.tls.shared_san
}

output "vault_ca_pem" {
  value = module.tls.root_ca_pem
}

output "resource_group" {
  value = local.resource_group
}

output "vault_subnet_id" {
  value = module.vnet.vault_subnet_id
}

output "proxy_subnet_id" {
  value = module.vnet.proxy_subnet_id
}

output "proxy_vm_ip" {
  value = module.proxy.proxy_vm_ip
}

output "virtual_network_name" {
  value = module.vnet.virtual_network_name
}

output "vault_cert_pem" {
  value = module.tls.node_cert_public_pem
}

output "vault_key_pem" {
  value = nonsensitive(module.tls.node_cert_private_pem)
}