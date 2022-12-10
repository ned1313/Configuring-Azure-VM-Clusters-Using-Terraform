variable "app_gateway_subnet_id" {
  type        = string
  description = "The subnet ID of the Application Gateway"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "prefix" {
  type        = string
  description = "The prefix to use for all resources in this module"
}

variable "app_gateway_sku" {
  type        = string
  description = "The SKU of the Application Gateway"
  default     = "Standard_Small"
}

variable "app_gateway_tier" {
  type        = string
  description = "The tier of the Application Gateway"
  default     = "Standard"
}

variable "app_gateway_capacity" {
  type        = number
  description = "The capacity of the Application Gateway"
  default     = 2
}

variable "frontend_port" {
  type        = number
  description = "The frontend port of the Application Gateway"
  default     = 80
}

variable "backend_port" {
  type        = number
  description = "Backend port of the targer pool"
  default     = 80
}

variable "vmss_sku" {
  type        = string
  description = "The SKU of the VMSS"
  default     = "Standard_D2_v3"
}

variable "vmss_instances" {
  type        = number
  description = "The initial capacity of the VMSS"
  default     = 2
}

variable "vmss_admin_username" {
  type        = string
  description = "The admin username of the VMSS"
}

variable "vmss_admin_ssh_key" {
  type        = string
  description = "The admin SSH key of the VMSS"
}

variable "vmss_source_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "vmss_os_disk_storage_account_type" {
  type        = string
  description = "The storage account type of the VMSS OS disk"
  default     = "Standard_LRS"
}

variable "vmss_os_disk_caching" {
  type        = string
  description = "The caching type of the VMSS OS disk"
  default     = "ReadWrite"
}

variable "vmss_zones" {
  type        = list(string)
  description = "The zones of the VMSS"
  default     = null
}

variable "vmss_subnet_id" {
  type        = string
  description = "The subnet ID of the VMSS"
}