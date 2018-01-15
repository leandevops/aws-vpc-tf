region = "eu-central-1"
name = "my-vpc"
environment = "development"
vpc_cidr = "10.0.0.0/16"

public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]

map_public_ip_on_launch = true
enable_nat_gateway = true
multi_nat_gateway = false
