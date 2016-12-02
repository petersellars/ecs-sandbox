/* User Data Template for ECS Instances */
data "template_file" "ecs_instance_user_data" {
  template = "${file("templates/ecs-instance-user-data.tpl")}"

  vars {
    ecs_cluster_name = "${var.ecs_cluster_name}"
  }
}
