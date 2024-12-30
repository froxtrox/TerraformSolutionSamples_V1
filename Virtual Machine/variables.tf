# Subscription and Location
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "UKSouth"
}

# Resource Naming
variable "resource_prefix" { 
  type        = string
}

# Tags
variable "tags_vmgroup" { 
  type        = string
}

# VM Configuration
variable "admin_username" { 
  type        = string
}

variable "admin_password" { 
  type        = string
  sensitive   = true
}

variable "vm_size" { 
  description = "Virtual Machine SKU"
  type        = string 
}

# Network Configuration
variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

# Storage Configuration
variable "os_disk_name" { 
  type        = string
}

variable "storage_account_type" { 
  type        = string
  default     = "Standard_LRS"
}

variable "disk_create_option" { 
  type        = string
  default     = "FromImage"
}

# VM Image Configuration
variable "hyper_v_generation" { 
  type        = string
  default     = "V1"
}

variable "image_reference_id" { 
  type        = string
  default     = "/Subscriptions/c7a11479-900a-4795-b9d9-9a4ac1779cb9/Providers/Microsoft.Compute/Locations/uksouth/Publishers/MicrosoftWindowsServer/ArtifactTypes/VMImage/Offers/WindowsServer/Skus/2016-Datacenter/Versions/latest"
}

# Virtual Machine Configuration
variable "vm_os_disk_caching" { 
  type        = string
  default     = "ReadWrite"
}

variable "vm_os_disk_storage_account_type" { 
  type        = string
  default     = "Standard_LRS"
}



variable "vm_source_image_publisher" {
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "vm_source_image_offer" {
  type        = string
  default     = "WindowsServer"
}

variable "vm_source_image_sku" {
  type        = string
  default     = "2016-Datacenter"
}

variable "vm_source_image_version" {
  type        = string
  default     = "latest"
}
