variable "virtual_machine_name" {
  type        = string
  default     = "SkyVM"
  description = "Name of the Virtual Machine."
}

variable "ssh_public_key_name" {
  type        = string
  default     = "SSHPublickey"
  description = "Name of the SSH Key"
}

variable "virtual_machine_size" {
  type        = string
  default     = "Standard_B2s"
  description = "Size or SKU of the Virtual Machine."
}

variable "username" {
  type        = string
  default     = "SkyUser"
  description = "The username for the local account that will be created on the new VM."
}

variable "password" {
  type        = string
  default     = "SkyPassord123"
  description = "The passoword for the local account that will be created on the new VM."
}

variable "resource_group_location" {
  type        = string
  default     = "Norway East"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "SkyVM_rg1"
  description = "Name of the resource group."
}

variable "InterIDweb" {

  description = "Interface ID"
}

variable "webpublicIP" {

  description = "PublicIp for webserver"
}