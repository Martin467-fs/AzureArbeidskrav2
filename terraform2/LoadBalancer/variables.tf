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
  default     = "SkyVM_rg"
  description = "Name of the resource group."
}

variable "PrivatIP_navn" {
  type        = string
  default     = "PrivatIP1"
  description = "Name of the PrivatIP"
}

variable "publicIPnavnlb" {

  description = "Name of the PrivatIP"
}

variable "privIPlb" {

  description = "Name of the PrivatIP"
}

variable "subnetIDlb" {

  description = "Name of the subnetID"
}