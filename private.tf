##############################
# private networking
##############################

# Create private networks
resource "aws_subnet" "private" {
  count                   = "${length(var.private_subnets)}"
  vpc_id                  = "${aws_vpc.self.id}"
  cidr_block              = "${var.private_subnets[count.index]}"
  map_public_ip_on_launch = "false"

  tags {
    Name              = "${var.environment}-public-${count.index}"
    builtWith         = "terraform"
    KubernetesCluster = "${var.name}"
  }
}

# Create elastic IP for nat gateway
resource "aws_eip" "self" {
  count = "${var.enable_nat_gateway ? (var.multi_nat_gateway ? length(var.public_subnets) : 1) : 0}"
  vpc   = true
}

# Create nat gateway
resource "aws_nat_gateway" "self" {
  # create net gateway if enable_nat_gateway is set to true
  # create more than 1 gateway if multi_nat_gateway is set to true
  count = "${var.enable_nat_gateway ? (var.multi_nat_gateway ? length(var.public_subnets) : 1) : 0}"

  allocation_id = "${aws_eip.self.*.id[count.index]}"
  subnet_id     = "${aws_subnet.public.*.id[count.index]}"
}

# Create route table for private network
resource "aws_route_table" "private" {
  count  = "${length(var.public_subnets)}"
  vpc_id = "${aws_vpc.self.id}"

  tags {
    Name              = "${var.environment}-private-route_table"
    builtWith         = "terraform"
    KubernetesCluster = "${var.name}"
  }
}

# Create route for private network
resource "aws_route" "through_nat_gateway" {
  count = "${var.enable_nat_gateway ? (var.multi_nat_gateway ? length(var.public_subnets) : 1) : 0}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.self.*.id, count.index)}"
}

# # create association with route
resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
