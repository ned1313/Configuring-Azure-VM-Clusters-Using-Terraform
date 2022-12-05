variable "admin_username" {
  type        = string
  description = "The username of the admin account for the proxy VM. Defaults to proxyadmin."
  default     = "proxyadmin"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "The password of the admin account for the proxy VM."
}

variable "common_tags" {
  default     = {}
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}

variable "prefix" {
  type        = string
  description = "(Required) Naming prefix for resources."
}

variable "location" {
  type        = string
  description = "(Optional) Region for Azure resources, defaults to East US."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create resources in. If not provided, a new resource group will be created."
}

variable "proxy_subnet_id" {
  type        = string
  description = "The subnet ID for the proxy subnet."
}

variable "root_ca_cert" {
  type        = string
  description = "The root CA certificate for the Vault cluster."
}

variable "vm_size" {
  type        = string
  description = "(Optional) VM size for app. Defaults to Standard_D2s_v5."
  default     = "Standard_D2s_v5"
}