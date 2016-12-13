/* Application Load Balancer */
resource "aws_alb" "mod" {
  name            = "${var.name}"
  internal        = "${var.internal}"
  subnets         = ["${var.subnets}"]
  security_groups = ["${aws_security_group.allow_https.id}",
		     "${var.vpc_default_security_group_id}"]

  tags {
    Environment = "${var.environment}"
  }
}
