######################
# VPC Endpoint for S3
######################
data "aws_vpc_endpoint_service" "s3" {
  count = "${var.enable_s3_endpoint ? 1 : 0}"

  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = "${var.enable_s3_endpoint ? 1 : 0}"

  vpc_id       = "${aws_vpc.self.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = "${var.enable_s3_endpoint && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = "${var.enable_s3_endpoint && length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.public.id}"
}
