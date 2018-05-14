##############################
# public networking
##############################

# Create an Internet gateway for internet access
resource "aws_internet_gateway" "self" {
  count  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.self.id}"

  tags = "${merge(var.tags, map("Name", format("%s-internet-gateway", var.name)))}"
}

# Create a route table
resource "aws_route_table" "public" {
  count  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.self.id}"

  tags = "${merge(var.tags, map("Name", format("%s-public-route_table", var.name)))}"
}

# Create a route
resource "aws_route" "public_to_internet" {
  count                  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.self.id}"
}

# Create public networks count based on var.public_subnets from top
resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = "${aws_vpc.self.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${merge(var.tags, map("Name", format("%s-public-%d", var.name, count.index)))}"
}

# Associate public networks with route table
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}
