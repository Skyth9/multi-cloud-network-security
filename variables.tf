variable "az_clientid" {}

variable "az_client_secr" {}

variable "az_subscrid" {}

variable "az_tenantid" {}

variable "naming_prefix" {
  type    = string
  default = "dcp"
}

variable "environment" {
  type    = string
  default = "lab"
}

variable "user" {
  type    = string
  default = "dobri"
}

variable "pass" {
  type      = string
  sensitive = true
  default ="123"
}