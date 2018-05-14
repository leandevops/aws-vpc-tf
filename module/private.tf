##############################
# private networking
##############################

# Create private networks
resource "aws_subnet" "private" {
  count                   = "${length(var.private_subnets)}"
  vpc_id                  = "${aws_vpc.self.id}"
  cidr_block              = "${var.private_subnets[count.index]}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${merge(var.tags, map("Name", format("%s-private-%d", var.name, count.index)))}"
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

# Create route table for each of private network
resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets)}"
  vpc_id = "${aws_vpc.self.id}"

  tags = "${merge(var.tags, map("Name", format("%s-private-route_table", var.name)))}"
}

# Create route for private network
resource "aws_route" "through_nat_gateway" {
  count = "${var.enable_nat_gateway ? length(var.public_subnets) : 0}"

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
