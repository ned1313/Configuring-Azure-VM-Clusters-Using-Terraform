variable "resource_group_name" {
  type        = string
  description = "(Required) Name of resource group to use for Vault."
}

variable "vm_count" {
  type        = number
  description = "(Required) Number of Vault servers to deploy. Must be an odd number."

  validation {
    condition     = var.vm_count % 2 == 1
    error_message = "Vault cluster must have an odd number of servers."
  }
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
  description = "(Required) Username for Vault servers."
}

variable "admin_public_key" {
  type        = string
  description = "(Required) Public key for Vault servers."
}

variable "zones" {
  type        = list(number)
  description = "(Required) List of availability zones to deploy Vault servers into."
}

variable "vm_size" {
  type        = string
  description = "(Required) Size of Vault servers. Must be an E-series or D-series VM."

  validation {
    condition     = contains(["Standard_E", "Standard_D"], substr(var.vm_size, 0, 10))
    error_message = "Vault servers must be an E-series or D-series VM."
  }
}

variable "vault_version" {
  type        = string
  description = "(Required) Version of Vault to deploy."
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
  description = "(Required) Tag to use for Vault servers."
}

variable "vault_san_name" {
  type        = string
  description = "(Required) SAN name for Vault servers."
}

variable "data_disk_size_gb" {
  type        = number
  description = "(Required) Size of data disk in GB."
}

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Tags to use for Vault servers. Defaults to empty"
  default     = {}
}


  