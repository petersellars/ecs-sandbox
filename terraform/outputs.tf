/* VPC Information */
output "lic_vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "lic_default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}

output "lic_internet_gateway_id" {
  value = "${module.vpc.internet_gateway_id}"
}

output "lic_public_route_table_ids" {
  value = "${module.vpc.public_route_table_ids}"
}

output "lic_private_route_table_id" {
  value = "${module.vpc.private_route_table_ids}"
}

/* Private Subnet Information */
output "lic_private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "lic_nat_eips" {
  value = "${module.vpc.nat_eips}"
}

/* Public Subnet Information */
output "lic_public_subnets" {
  value = "${module.vpc.public_subnets}"
}

/* RDS Information */
output "identity_service_instance_id" {
  value = "${module.fp-identity-service.rds_instance_id}"
}

output "identity_service_instance_address" {
  value = "${module.fp-identity-service.rds_instance_address}"
}
