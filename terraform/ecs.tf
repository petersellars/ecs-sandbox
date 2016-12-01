/* ECS Service Cluster */
resource "aws_ecs_cluster" "ecs" {
  name = "${var.ecs_cluster_name}"
}

/* Autoscaling Group */
resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-asg"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  availability_zones   = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier  = ["${split(",", var.subnet_ids)}"]
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  desired_capacity     = "${var.desired_capacity}"

  lifecycle {
    create_before_destroy = true
  }
}
