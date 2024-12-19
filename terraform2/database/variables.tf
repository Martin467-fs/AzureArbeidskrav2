variable "servername" {
  type        = string
  default     = "martinsql"
  description = " Name of the Flexible Server"
}

variable "serveradminuser" {
  type        = string
  default     = "psqladmin"
  description = " Name of the Server Admin Username"
}

variable "serveradminpass" {
  type        = string
  default     = "H@Sh1CoR3!"
  description = " Name of the Server Admin Password"
}

variable "databasename" {
  type        = string
  default     = "database1"
  description = " Name of the Flexible Database"
}

variable "nicname" {
  type = string
  default = "nicdb"
  description = "Name of the nic for DBs"
}

variable "usernamedb" {
  type        = string
  default     = "DBUser"
  description = "The username for the local account that will be created on the new VM."
}

variable "passworddb" {
  type        = string
  default     = "DBPassord123"
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

variable "ssh_public_key_name" {
  type        = string
  default     = "SSHPublickeydb"
  description = "Name of the SSH Key"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the network security group."
  default     = "NSGDB"
}

variable "storage_accountname" {
  description = "Name of the Storage Account"
  type = string
  default = "oppgaventilhavard"
}

variable "publicIPnavndb" {

  description = "Name of the PrivatIP"
}

variable "privIPdb" {

  description = "Name of the PrivatIP"
}

variable "subnetIDdb" {

  description = "Name of the subnetID"
}

variable "Internamedb" {

  description = "Name of the Interface"
}

variable "bpepooliddb" {

  description = "ID for backend pool"
}

variable "publicIPnatid" {

  description = "ID for the NAT public IP"
}