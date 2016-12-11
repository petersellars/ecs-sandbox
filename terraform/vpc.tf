resource "aws_vpc" "ecs" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags {
    Name = "VPC-Test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id          = "${aws_vpc.ecs.id}"
  service_name    = "com.amazonaws.ap-southeast-2.s3"
  route_table_ids = ["${aws_route_table.ecs_private.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.ecs.id}"
}

output "vpc_default_security_group_id" {
  value = "${aws_vpc.ecs.default_security_group_id}"
}
