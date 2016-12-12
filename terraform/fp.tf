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

module "ecs_prod_cluster" {
  source              = "./ecs_cluster"
  environment         = "Production"
  name                = "LicNZ-FP-Prod"
  vpc_id              = "${module.vpc.vpc_id}"
  key_name            = "${var.key_name}"
  key_file            = "${var.key_file}"
  s3_bucket_name      = "lic-ecs-prod"
  availability_zones  = ["ap-southeast-2a", "ap-southeast-2b"]
  image_id            = "${lookup(var.amis, var.region)}"
  vpc_zone_identifier = ["${module.vpc.private_subnets}"]
  ecs_engine_auth     = "${var.ecs_engine_auth}"
}

/*
module "ecs_accp_cluster" {
  source              = "./ecs_cluster"
  environment         = "Acceptance"
  name                = "LicNZ-FP-Accp"
  vpc_id              = "{module.vpc.vpc_id}"
  key_name            = "${var.key_name}"
  key_file            = "${var.key_file}"
  s3_bucket_name      = "lic-ecs-accp"
  availability_zone   = ["ap-southeast-2a", "ap-southeast-2b"]
  image_id            = "${lookup(var.amis, var.region)}"
  vpc_zone_identifier = ["${module.vpc.private_subnets}"]
  ecs_engine_auth     = "${var.ecs_engine_auth}"
}
*/

module "ecs_alb" {
  source             = "./alb"
  name               = "ecs-alb"
  vpc_id             = "${module.vpc.vpc_id}"
  subnets            = ["${module.vpc.public_subnets}"]
  target_group       = "LicNZ-FP-Target-Group"
  certificate_domain = "*.catosplace.biz"
}

/*
module "fp-identity-service" {
  source = "./fp-service"
  name   = "identity"
}
*/
