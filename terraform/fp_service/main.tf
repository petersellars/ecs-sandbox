/* Task Definition */
resource "aws_ecs_task_definition" "mod" {
  family                = "${var.family}"
  container_definitions = "${data.template_file.task_definition.rendered}"
  
  depends_on            = ["aws_db_instance.service","aws_cloudwatch_log_group.mod"]
}

/* Service */
resource "aws_ecs_service" "mod" {
  name            = "${var.name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.mod.arn}"
  desired_count   = 1
  iam_role        = "${var.ecs_service_role}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.mod.arn}"
    container_name   = "${var.name}"
    container_port   = "${var.port}"
  }
}

/* Service Target Group for use with ALB */
resource "aws_alb_target_group" "mod" {
  name            = "${var.name}-tg"
  port            = 80
  protocol        = "HTTP"
  vpc_id          = "${var.vpc_id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5 
    path                = "${var.hc_path}"
    port                = "traffic-port"
    interval            = 30
  }
}

/* Service ALB HTTPS Listener - NB. All HTTPS */
resource "aws_alb_listener" "mod" {
  load_balancer_arn = "${var.load_balancer}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${data.aws_acm_certificate.mod.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.mod.arn}"
    type             = "forward"
  }
}

/* SSL Certificate for use with HTTPS Listener */
data "aws_acm_certificate" "mod" {
  domain   = "${var.certificate_domain}"
  statuses = ["ISSUED"]
}

/* Route DNS to the ALB */
resource "aws_route53_record" "mod" {
  zone_id = "${var.hosted_zone_id}"
  name    = "${var.route53_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.load_balancer_dns_name}"]
}

/* Add Cloudwatch Log Group */
resource "aws_cloudwatch_log_group" "mod" {
  name = "awslogs-${var.name}"
}
