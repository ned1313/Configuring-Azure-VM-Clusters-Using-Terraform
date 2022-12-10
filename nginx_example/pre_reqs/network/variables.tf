variable "address_space" {
  default     = "10.0.0.0/16"
  description = "Virtual Network address space"
  type        = string
}

variable "common_tags" {
  default     = {}
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}

variable "resource_group" {
  description = "Azure resource group in which resources will be deployed"

  type = object({
    location = string
    name     = string
  })
}

variable "resource_name_prefix" {
  default     = "dev"
  description = "Prefix for resource names (e.g. \"prod\")"
  type        = string
}

variable "nginx_address_prefix" {
  default     = "10.0.1.0/24"
  description = "nginx VM Virtual Network subnet address prefix"
  type        = string
}

variable "app_gateway_address_prefix" {
  default     = "10.0.2.0/24"
  description = "Application Gateway Virtual Network subnet address prefix"
  type        = string
}