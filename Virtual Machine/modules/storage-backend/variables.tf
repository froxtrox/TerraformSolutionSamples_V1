variable "location" {
  description = "Azure region"
  type        = string
  default     = "UKSouth"
}

variable "resource_group_name" { 
  type        = string 
}

variable "storage_account_name" { 
  type        = string 
}

variable "storage_container_name" { 
  type        = string 
}