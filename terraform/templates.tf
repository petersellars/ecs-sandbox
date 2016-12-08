/* ECS Config Template */
data "template_file" "ecs_config" {
  template = "${file("templates/ecs-config.tpl")}"

  vars {
    ecs_cluster_name = "${var.ecs_cluster_name}"
    ecs_engine_auth  = "${var.ecs_engine_auth}"
  }
}

/* User Data Template for ECS Instances */
data "template_file" "ecs_instance_user_data" {
  template = "${file("templates/ecs-instance-user-data.tpl")}"

  vars {
    s3_bucket_name = "${var.s3_bucket_name}"
  }
}
