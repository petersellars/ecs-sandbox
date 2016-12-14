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

/* Route DNS to the ALB */
resource "aws_route53_record" "mod" {
  zone_id = "${var.hosted_zone_id}"
  name    = "${var.route53_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.mod.dns_name}"]
}
