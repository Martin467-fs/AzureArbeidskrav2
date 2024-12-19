variable "load_balancer_name" {
  type        = string
  description = "Name of the load balancer."
  default     = "LoadBalancer"     
}

variable "BackEnd_AddressPool_Name" {
  type        = string
  description = "Name of the BackEndAddressPool"
  default     = "BackEndAddressPool"
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

variable "PrivatIP_navn" {
  type        = string
  default     = "PrivatIP1"
  description = "Name of the PrivatIP"
}

variable "privIPlb" {
  type = string
  default = "10.0.0.4"
  description = "frontend ip for the lb"
}

variable "subnetIDlb" {

  description = "Name of the subnetID"
}

variable "privateIPnavnlb" {

  description = "Name of the frontend privateIP"
}