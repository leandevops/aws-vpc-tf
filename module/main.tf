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

####################
# data providers
####################
data "aws_availability_zones" "available" {}
