#----------------------------------------------------------------------
# This module creates:
# * vpc
# * 2 private and 2 public networks
# * No public addresses mapping for hosts in public networks
#----------------------------------------------------------------------

module "vpc" {
  source = "github.com/leandevops/terraform-aws-vpc//module?ref=v1.1.0"

  name     = "test-vpc"
  region   = "${var.region}"
  vpc_cidr = "10.0.0.0/16"

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]

  # the default value for map_public_ip_on_launch is true
  # this way, the line  map_public_ip_on_launch = true can be omitted
  # so if you want to prevent mapping set it to false explicitly
  map_public_ip_on_launch = false
}

variable "region" {
  default = "us-east-1"
}
