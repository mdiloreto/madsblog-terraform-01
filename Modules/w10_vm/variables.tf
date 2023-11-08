variable "rg" {
  description = "RG Name!"
  default = "w10-rg"
}

variable "vmname" {
  description = "Virtual Machine Name"
  default = "w10"
}

variable "location" {
  default = "eastus"
}

variable "admin_username" {
  default = "admin_user01"
}

variable "admin_password" {
  default = "MadsBlog_2023!!"
}

variable "create_rg" {
  default = "true"
}

variable "vnet" {
  description = "Name of the vnet"
  default = "default-vm-vnet"
}

variable "create_vnet" {
  description = "Whether to create a new resource group or use an existing one"
  type        = bool
  default = "true"
}

variable "subnet_id" {
  description = "The ID of the subnet where the VM should be placed"
  type        = string
}
