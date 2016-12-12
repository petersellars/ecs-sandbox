/* ECS Service Cluster */
resource "aws_ecs_cluster" "ecs" {
  name = "${var.ecs_cluster_name}"
}

/* ECS S3 bucket */
resource "aws_s3_bucket" "ecs" {
  bucket        = "${var.s3_bucket_name}"
  force_destroy = true
  
  versioning {
    enabled = true
  }

  tags {
    Name = "LIC ECS Configuration"
  }
}

/* Add ecs.config to the ECS S3 bucket */
resource "aws_s3_bucket_object" "ecs_config" {
  bucket  = "${aws_s3_bucket.ecs.bucket}"
  key     = "ecs.config"
  content = "${data.template_file.ecs_config.rendered}"
}

/* Autoscaling Group */
resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-asg"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  availability_zones   = ["ap-southeast-2a","ap-southeast-2b"]
  vpc_zone_identifier  = ["${module.vpc.private_subnets}"]
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  desired_capacity     = "${var.desired_capacity}"
  
  lifecycle {
    create_before_destroy = true
  }

  depends_on           = ["aws_s3_bucket.ecs"]
}
