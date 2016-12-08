/* SSH Key Pair */
resource "aws_key_pair" "ecs" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}

/* EC2 Launch Configuration */
resource "aws_launch_configuration" "ecs" {
  name_prefix          = "ECS-${var.ecs_cluster_name}-"
  image_id             = "${lookup(var.amis, var.region)}" 
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  key_name             = "${aws_key_pair.ecs.key_name}"
  security_groups      =  ["${aws_security_group.ecs.id}"]
  user_data            = "${data.template_file.ecs_instance_user_data.rendered}" 

  lifecycle {
    create_before_destroy = true
  }
}
