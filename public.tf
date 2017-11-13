##############################
# public networking
##############################

# Create an Internet gateway for internet access
resource "aws_internet_gateway" "self" {
  count  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.self.id}"

  tags {
    Name              = "${var.name}"
    builtWith         = "terraform"
    KubernetesCluster = "${var.name}"
    visibility        = "private,public"
    environment       = "${var.environment}"
  }
}

# Create a route table
resource "aws_route_table" "public" {
  count  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.self.id}"

  tags {
    Name              = "${var.environment}-public-route_table"
    builtWith         = "terraform"
    KubernetesCluster = "${var.name}"
  }
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
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name              = "${var.environment}-public-${count.index}"
    builtWith         = "terraform"
    KubernetesCluster = "${var.name}"
  }
}

# Associate public networks with route table
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}
