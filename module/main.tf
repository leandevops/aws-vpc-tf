terraform {
  required_version = ">= 0.10.3"
}

#################
## VPC
#################
resource "aws_vpc" "self" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

###################
# DHCP Options Set
###################
resource "aws_vpc_dhcp_options" "self" {
  count = "${var.enable_dhcp_options ? 1 : 0}"

  domain_name          = "${var.dhcp_options_domain_name}"
  domain_name_servers  = ["${var.dhcp_options_domain_name_servers}"]
  ntp_servers          = ["${var.dhcp_options_ntp_servers}"]
  netbios_name_servers = ["${var.dhcp_options_netbios_name_servers}"]
  netbios_node_type    = "${var.dhcp_options_netbios_node_type}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

###############################
# DHCP Options Set Association
###############################
resource "aws_vpc_dhcp_options_association" "self" {
  count = "${var.enable_dhcp_options ? 1 : 0}"

  vpc_id          = "${aws_vpc.self.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.self.id}"
}

####################
# data providers
####################
data "aws_availability_zones" "available" {}
