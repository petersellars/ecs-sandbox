/* VPC */
module "vpc" {
  source                  = "./vpc"
  name                    = "Catosplace-ECS-Sandbox"
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
  name                = "Catosplace-Prod"
  registry            = "registry.gitlab.com" 
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
  name                = "Catosplace-Accp"
  registry            = "index.docker.io/v1/"
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

module "ecs_prod_alb" {
  source                        = "./alb"
  environment                   = "Production"
  name                          = "ecs-prod-alb"
  vpc_id                        = "${module.vpc.vpc_id}"
  vpc_default_security_group_id = "${module.vpc.default_security_group_id}"
  subnets                       = ["${module.vpc.public_subnets}"]
}

/**
 * Services 
 *   - Seperate Infrastructure from Application Deployment 
 **/

module "fp-identity-service" {
  source                 = "./fp_service"
  environment            = "Production"
  name                   = "identity-service"
  family                 = "identity-service"
  image                  = "registry.gitlab.com/lic-nz/identity:latest"
  port                   = "5000"
  hc_path                = "/users/sign_in"
  db_password            = "${var.identity_db_password}"
  vpc_id                 = "${module.vpc.vpc_id}"
  private_subnets        = "${module.vpc.private_subnets}"
  cluster_id             = "${module.ecs_prod_cluster.cluster_id}"
  ecs_service_role       = "${module.ecs_prod_cluster.ecs_service_role_arn}"
  load_balancer          = "${module.ecs_prod_alb.alb_arn}"
  load_balancer_dns_name = "${module.ecs_prod_alb.dns_name}"
  certificate_domain     = "*.catosplace.biz"
  hosted_zone_id         = "${var.hosted_zone_id}"
  route53_domain         = "sandbox.catosplace.biz"
}

module "bastion" {
  source                      = "./bastion"
  instance_type               = "t2.micro"
  ami                         = "ami-90724af3"
  region                      = "ap-southeast-2"
  s3_bucket_name              = "fp-bastion-keys-bucket"
  vpc_id                      = "${module.vpc.vpc_id}"
  subnet_ids                  = ["${module.vpc.public_subnets}"]
  keys_update_frequency       = "5,20,35,50 * * * *"
  additional_user_data_script = "date"
}
