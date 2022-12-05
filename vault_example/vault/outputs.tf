output "vault_cluster_address" {
  value = module.vault_cluster.vault_cluster_address
}

output "vault_cluster_ip_addresses" {
  value = module.vault_cluster.vault_cluster_ip_addresses
}

output "private_ssh_key" {
  value = var.admin_public_key == null ? nonsensitive(tls_private_key.main[0].private_key_openssh) : null
}