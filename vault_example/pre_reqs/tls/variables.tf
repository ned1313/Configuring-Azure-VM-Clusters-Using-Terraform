variable "shared_san" {
  default     = "vault.server.com"
  description = "This is a shared server name that the certs for all Vault nodes contain. This is the same value you will supply as input to the Vault installation module for the leader_tls_servername variable."
  type        = string
}