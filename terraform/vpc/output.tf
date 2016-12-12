output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "default_security_group_id" {
  value = "${aws_vpc.mod.default_security_group_id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.mod.id}"
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "nat_eips" {
  value = ["${aws_eip.nateip.*.id}"]
}
