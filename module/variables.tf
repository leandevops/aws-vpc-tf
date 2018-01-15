##############################
# input and output variables
##############################
variable "name" {
  description = "a name for tagging"
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC."
}

variable "region" {
  description = "The AWS region."
}

variable "environment" {
  description = "The name of our environment, i.e. development."
}

variable "enable_dns_hostnames" {
  description = "Should be set to true to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be set true to use private DNS within the VPC"
  default     = true
}

variable "public_subnets" {
  description = "The list of public subnets to populate."
  default     = []
}

variable "private_subnets" {
  description = "The list of private subnets to populate."
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnet"
  default     = true
}

variable "enable_nat_gateway" {
  description = "Set to TRUE to enable nat gateway for private network"
  default     = false
}

variable "multi_nat_gateway" {
  description = "Set to TRUE to create multiple nat gateways for each private subnet"
  default     = false
}
