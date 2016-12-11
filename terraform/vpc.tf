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

output "vpc_id" {
  value = "${aws_vpc.ecs.id}"
}

output "vpc_default_security_group_id" {
  value = "${aws_vpc.ecs.default_security_group_id}"
}
