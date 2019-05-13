# Terraform module for AWS VPC creation
[![Maintained by Leandevops.io](https://img.shields.io/badge/maintained%20by-leandevops-green.svg)](https://img.shields.io/badge/maintained%20by-leandevops-green.svg)
[![CircleCI](https://circleci.com/gh/leandevops/terraform-aws-vpc.svg?style=svg)](https://circleci.com/gh/leandevops/terraform-aws-vpc)

## Module Variables

| Name   |    Description |
|--------|--------------|
| `name` | name to be used on all the resources created by the module |
| `vpc_cidr` | the CIDR block for the VPC |
| `public_subnets` | the list of public subnet CIDRs |
| `private_subnets` | the list of private subnet CIDRs |
| `enable_dns_hostnames` | should be true if you want to use private DNS within the VPC |
| `enable_dns_support` | should be set true to use private DNS within the VPC |
| `enable_nat_gateway` | should be true if you want to provision NAT Gateways (default - false) |
| `multi_nat_gateway` | should be true if you want to provision a multiple NAT Gateways across all of your private networks (default - false)|
| `map_public_ip_on_launch` | should be false if you do not want to auto-assign public IP on launch (default - true) |
| `enable_dhcp_options` | should be set to true if you want to create a dhcp options for vpc |
| `dhcp_options_domain_name` | specify a domain name |
| `enable_s3_endpoint` | create S3 enpoint and corresponding routes |

## Usage

```hcl
module "vpc" {
  source = "github.com/leandevops/terraform-aws-vpc//module?ref=v1.1.0"

  name        = "kubernetes-vpc"  
  region      = "${var.region}"
  vpc_cidr    = "10.0.0.0/16"

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]

  enable_dhcp_options      = true
  dhcp_options_domain_name = "${var.domain_name}"

  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  multi_nat_gateway       = true
}
```
To see more examples of using this module, refer to [examples](https://github.com/leandevops/terraform-aws-vpc/tree/master/examples) directory.

## Outputs
| Name   |  Description |
|--------|--------------|
| `vpc_id` | the VPC id |
| `public_subnets` | list of public subnet ids |
| `private_subnets` | list of private subnet ids |
| `default_sg` | VPC default security group id |
| `allow_ssh-sg` | allow_ssh security group id |

## How do I contribute to this Module?
Contributions are very welcome! Check out the 
[Contribution Guidelines]() for instructions.

## License
This code is released under the Apache 2.0 License. Please see [LICENSE](https://github.com/leandevops/terraform-aws-vpc/tree/master/LICENSE) for more details.

Copyright © 2019 [LeanDevops](https://leandevops.io).
