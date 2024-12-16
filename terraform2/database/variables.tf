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
  default     = "SkyVM_rg"
  description = "Name of the resource group."
}