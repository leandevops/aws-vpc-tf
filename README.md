# AWS VPC terraform module
[![Maintained by Leandevops.io](https://img.shields.io/badge/maintained%20by-leandevops-green.svg)](https://img.shields.io/badge/maintained%20by-leandevops-green.svg)

## Module Variables

- `name` - name to be used on all the resources created by the module
- `vpc_cidr` - the CIDR block for the VPC
- `environment` - name of our environment, i.e. development.
- `public_subnets` - list of public subnet cidrs
- `private_subnets` - list of private subnet cidrs
- `enable_dns_hostnames` - should be true if you want to use private DNS within the VPC
- `enable_dns_support` - should be set true to use private DNS within the VPC
- `enable_nat_gateway` - should be true if you want to provision NAT Gateways (default - false)
- `multi_nat_gateway` - should be true if you want to provision a multiple NAT Gateways across all of your private networks (default - false)
- `map_public_ip_on_launch` - should be false if you do not want to auto-assign public IP on launch
- `enable_dhcp_options` - should be set to true if you want to create a dhcp options for vpc
- `dhcp_options_domain_name` - specify a domain name
- `enable_s3_endpoint` - create S3 enpoint and corresponding routes

## Usage

```hcl
module "vpc" {
  source = "github.com/lestex/aws-vpc-tf/module"

  name        = "aws-kubernetes"
  environment = "development"
  region      = "${var.region}"
  vpc_cidr    = "10.0.0.0/16"

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]

  enable_dhcp_options      = true
  dhcp_options_domain_name = "${local.domain_name}"

  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  multi_nat_gateway       = true
}
```

## Outputs

- `vpc_id` - the VPC id
- `public_subnets` - list of public subnet ids
- `private_subnets` - list of private subnet ids
- `default_sg` - VPC default security group id
- `allow_ssh-sg` - allow_ssh security group id

## Author

Created and maintained by [Andrey Larin](https://github.com/lestex)

## License

Apache 2 Licensed. See LICENSE for full details.
