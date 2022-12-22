output "root_ca_pem" {
  value = tls_self_signed_cert.ca.cert_pem
}

output "node_cert_public_pem" {
  value = tls_locally_signed_cert.server.cert_pem
}

output "node_cert_private_pem" {
  sensitive = true
  value     = tls_private_key.server.private_key_pem
}

output "shared_san" {
  value = tls_cert_request.server.dns_names[0]
}