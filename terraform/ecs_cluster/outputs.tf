/* Cluster Information */
output "cluster_id" {
  value = "${aws_ecs_cluster.ecs.id}"
}

/* IAM Information */
output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs_service_role.arn}"
}

output "rds_ecs_sg_id" {
  value = "${aws_security_group.ecs_rds.id}"
}

/* Launch Configuration Information */
output "launch_configuration.id" {
  value = "${aws_launch_configuration.ecs.id}"
}

/* Autoscaling Group Information */
output "autoscaling.id" {
  value = "${aws_autoscaling_group.ecs.id}"
}

output "autoscaling.availability_zones" {
  value = "${aws_autoscaling_group.ecs.availability_zones}"
}

output "autoscaling.min_size" {
  value = "${aws_autoscaling_group.ecs.min_size}"
}

output "autoscaling.max_size" {
  value = "${aws_autoscaling_group.ecs.max_size}"
}

output "autoscaling.default_cooldown" {
  value = "${aws_autoscaling_group.ecs.default_cooldown}"
}

output "autoscaling.name" {
  value = "${aws_autoscaling_group.ecs.name}"
}

output "autoscaling.health_check_grace_period" {
  value = "${aws_autoscaling_group.ecs.health_check_grace_period}"
}

output "autoscaling.health_check_type" {
  value = "${aws_autoscaling_group.ecs.health_check_type}"
}

output "autoscaling.desired_capacity" {
  value = "${aws_autoscaling_group.ecs.desired_capacity}"
}

output "autoscaling.launch_configuration" {
  value = "${aws_autoscaling_group.ecs.launch_configuration}"
}

output "autoscaling.vpc_zone_identifier" {
  value = "${aws_autoscaling_group.ecs.vpc_zone_identifier}"
}

output "autoscaling.load_balancers" {
  value = "${aws_autoscaling_group.ecs.load_balancers}"
}

/* S3 Configuration Version Information */
output "ecs_config.version_id" {
  value = "${aws_s3_bucket_object.ecs_config.version_id}"
}

