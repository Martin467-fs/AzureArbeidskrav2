variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network."
  default     = "VirtualNetwork"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet."
  default     = "Subnet"
}

variable "network_interface_name" {
  type        = string
  description = "Name of the network interface."
  default     = "Interface"
}

variable "ip_configuration_name" {
  type        = string
  description = "Name of the IP configuration."
  default     = "IP1"
}

variable "public_ip_name" {
  type        = string
  description = "Name of the public IP."
  default     = "PublicIP1"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the network security group."
  default     = "NSG"
}

variable "resource_group_location" {
  type        = string
  default     = "Norway East"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "SkyVM_rg"
  description = "Name of the resource group."
}