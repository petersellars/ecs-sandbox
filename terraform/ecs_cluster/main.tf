/* ECS Cluster */
resource "aws_ecs_cluster" "ecs" {
  name = "${var.name}"
}

/* ECS S3 Configuration Bucket */
resource "aws_s3_bucket" "ecs" {
  bucket        = "${var.s3_bucket_name}"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags {
    Name = "LIC ECS Configuration"
    Environment = "${var.environment}"
  }
}

/* Add ecs.config to the ECS S3 bucket */
resource "aws_s3_bucket_object" "ecs_config" {
  bucket  = "${aws_s3_bucket.ecs.bucket}"
  key     = "ecs.config"
  content = "${data.template_file.ecs_config.rendered}"
}

/* SSH Key Pair */
resource "aws_key_pair" "ecs" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}

/* EC2 Launch Configuration */
resource "aws_launch_configuration" "ecs" {
  name_prefix          = "ECS-${var.name}-"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  key_name             = "${aws_key_pair.ecs.key_name}"
  security_groups      =  ["${aws_security_group.ecs.id}","${aws_security_group.ecs_vpc.id}"]
  user_data            = "${data.template_file.ecs_instance_user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

/* Autoscaling Group */
resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-asg"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  availability_zones   = "${var.availability_zones}"
  vpc_zone_identifier  = ["${var.vpc_zone_identifier}"]
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  desired_capacity     = "${var.desired_capacity}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on           = ["aws_s3_bucket.ecs"]
}

