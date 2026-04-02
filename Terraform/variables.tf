# terraform/aws/modules/vpc/variables.tf

variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.0.0/26"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.0.64/26"
}

variable "tags" {
  type    = map(string)
  default = {}
}
