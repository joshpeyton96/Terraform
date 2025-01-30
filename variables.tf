variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "task2"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

variable "password" {
  type        = string
  description = "The password for the local account that will be created on the new VM."
  default     = "P@$$w0rd1234!"
}

variable "vm_name" {
  type = string
  default = "myVM-Josh"
}

variable "vm_size" {
  type = string
  default = "Standard_D2s_v3"
}
 
