variable "region" {}
variable "name" {}
variable "environment" {}
variable "vpc_cidr" {}

variable "public_subnets" {
  default = []
}

variable "private_subnets" {
  default = []
}

variable "map_public_ip_on_launch" {}
variable "enable_nat_gateway" {}
variable "multi_nat_gateway" {}
variable "tags" {}
