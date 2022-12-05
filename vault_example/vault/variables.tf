variable "location" {
  type        = string
  description = "(Required) The Azure location where all resources in this example should be created."
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Existing resource group to use for Vault. Defaults to null"
  default     = null
}

variable "cluster_size" {
  type        = number
  description = "(Optional) Number of Vault servers to deploy. Must be an odd number. Defaults to 3."
  default     = 3
}

variable "prefix" {
  type        = string
  description = "(Required) Prefix to use for naming resources."
}

variable "vault_subnet_id" {
  type        = string
  description = "(Required) ID of the subnet to deploy Vault servers into."
}

variable "admin_username" {
  type        = string
  description = "(Optional) Username for Vault servers. Defaults to vaultadmin"
  default     = "vaultadmin"
}

variable "admin_public_key" {
  type        = string
  description = "(Optional) Public key for SSH to Vault servers. Defaults to null"
  default     = null
}

variable "zones" {
  type        = list(number)
  description = "(Required) List of availability zones to deploy Vault servers into."
}

variable "vm_size" {
  type        = string
  description = "(Optional) Size of Vault servers. Must be an E-series or D-series VM. Defaults to Standard_D2s_v5"
  default     = "Standard_D2s_v5"
}

variable "vault_version" {
  type        = string
  description = "(Optional) Version of Vault to deploy. Defaults to 1.12.0"
  default     = "1.12.0"
}

variable "vault_cert_pem" {
  type        = string
  description = "(Required) PEM-encoded certificate for Vault."
}

variable "vault_key_pem" {
  type        = string
  description = "(Required) PEM-encoded private key for Vault."
}

variable "vault_ca_pem" {
  type        = string
  description = "(Required) PEM-encoded CA certificate for Vault."
}

variable "vault_tag" {
  type        = map(string)
  description = "(Optional) Tag to use for Vault servers. Defaults to null"
  default     = null
}

variable "vault_san_name" {
  type        = string
  description = "(Required) SAN name for Vault servers."
}

variable "data_disk_size_gb" {
  type        = number
  description = "(Optional) Size of data disk in GB. Defaults to 16"
  default     = 16
}


  