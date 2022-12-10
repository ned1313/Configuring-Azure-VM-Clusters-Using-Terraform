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

variable "location" {
  default     = "East US"
  description = "(Optional) The location/region to create the resource group (if one is not provided)"
  type        = string
}

variable "resource_group" {
  default     = null
  description = "(Optional) Azure resource group in which resources will be deployed; omit to create one"

  type = object({
    location = string
    name     = string
  })
}

variable "resource_name_prefix" {
  description = "Prefix applied to resource names"
  type        = string

  validation {
    condition     = length(var.resource_name_prefix) < 16 && (replace(var.resource_name_prefix, " ", "") == var.resource_name_prefix)
    error_message = "The resource_name_prefix value must be fewer than 16 characters and may not contain spaces."
  }
}

variable "nginx_address_prefix" {
  default     = "10.0.1.0/24"
  description = "NGINX VM Virtual Network subnet address prefix"
  type        = string
}

variable "app_gateway_address_prefix" {
  default     = "10.0.2.0/24"
  description = "App Gateway Virtual Network subnet address prefix"
  type        = string
}