/* SSH Key Pair */
resource "aws_key_pair" "ecs" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}

/* EC2 Launch Configuration */
resource "aws_launch_configuration" "ecs" {
  name_prefix          = "ECS-${var.ecs_cluster_name}"
  image_id             = "${lookup(var.amis, var.region)}" 
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  key_name             = "${aws_key_pair.ecs.key_name}"
  security_groups      = ["${split(".", var.security_group_ids)}"]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.ecs.name} > /etc/ecs/ecs.config" 

  lifecycle {
    create_before_destroy = true
  }
}
