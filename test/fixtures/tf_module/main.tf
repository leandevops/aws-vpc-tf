provider "aws" {
    region = "${var.region}"
}

module "module_test" {
    source = "../../.."

    region      = "${var.region}"
    name        = "${var.name}"
    environment = "${var.environment}"
    vpc_cidr    = "${var.vpc_cidr}"

    public_subnets  = ["${var.public_subnets}"]
    private_subnets = ["${var.private_subnets}"]

    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
    enable_nat_gateway      = "${var.enable_nat_gateway}"
    multi_nat_gateway       = "${var.multi_nat_gateway}"
}
