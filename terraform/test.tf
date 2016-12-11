/*
module "vpc" {
  source               = "./vpc"
  name                 = "ecs_test"
  cidr                 = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "ecs-2" {
  vpc_id = "${module.vpc.vpc_id}"

  tags {
    Name = "test-igw"
  }
}

output "ecs_vpc" {
  value = "${module.vpc.vpc_id}"
}
*/
