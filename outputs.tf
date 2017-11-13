######################################		
# output variables		
######################################		
output "vpc_id" {
  value = "${aws_vpc.self.id}"
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = "${aws_subnet.public.*.id}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${aws_subnet.private.*.id}"
}

output "default_sg" {
  value = "${aws_vpc.self.default_security_group_id}"
}

output "allow_ssh-sg" {
  value = "${aws_security_group.allow_ssh-sg.id}"
}
