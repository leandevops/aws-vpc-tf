##############################
# input variables
##############################
variable "region" {
  description = "The AWS region."
}

variable "name" {
  description = "a name for tagging"
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC."
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

variable "enable_dhcp_options" {
  default = false
}

variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set"
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided"
  type        = "list"
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set"
  type        = "list"
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set"
  type        = "list"
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set"
  default     = ""
}

variable "enable_s3_endpoint" {
  default = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
