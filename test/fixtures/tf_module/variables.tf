variable "region" {}
variable "name" {}
variable "environment" {}
variable "vpc_cidr" {}

variable "public_subnets" {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
    default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "map_public_ip_on_launch" {}
variable "enable_nat_gateway" {}
variable "multi_nat_gateway" {}
