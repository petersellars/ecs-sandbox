/* VPC */
module "vpc" {
  source                  = "./vpc"
  name                    = "LicNZ-Farm-Performance"
  cidr                    = "10.10.0.0/16"
  private_subnets         = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets          = ["10.10.101.0/24", "10.10.102.0/24"]
  availability_zones      = ["ap-southeast-2a", "ap-southeast-2b"]
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_nat_gateway      = "true"
}

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id          = "${module.vpc.vpc_id}"
  service_name    = "com.amazonaws.ap-southeast-2.s3"
  route_table_ids = ["${module.vpc.private_route_table_ids}"]
}

/*
module "ecs_prod_cluster" {
  source = "./ecs_cluster"
  name   = "LicNZ-FP-Prod"
}

module "ecs_accp_cluster" {
  source = "./ecs_cluster"
  name   = "LicNZ-FP-Accp"
}

module "fp-identity-service" {
  source = "./fp-service"
  name   = "identity"
}
*/
