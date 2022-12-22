variable "app_gateway_subnet_id" {
  type        = string
  description = "The subnet ID of the Application Gateway"
}

variable "prefix" {
  type        = string
  description = "The prefix to use for all resources in this module"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Existing resource group to use for Vault. Defaults to null"
  default     = null
}

variable "location" {
  type        = string
  description = "The location of the resources on Azure"
  default     = null
}

variable "vmss_admin_username" {
  type        = string
  description = "The admin username of the VMSS"
}

variable "vmss_admin_ssh_key" {
  type        = string
  description = "The admin SSH key of the VMSS"
  default     = null
}

variable "vmss_source_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "vmss_subnet_id" {
  type        = string
  description = "The subnet ID of the VMSS"
}

variable "create_index_html" {
  type        = bool
  description = "(Optional) Create an index.html file for the website. Used for testing."
  default     = false
}