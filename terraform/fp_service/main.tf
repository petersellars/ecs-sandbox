/* Jenkins Target Group for use with ALB */
resource "aws_alb_target_group" "jenkins" {
  name     = "jenkins-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    port                = 8080
    interval            = 30
  }

}

/* SSL Certificate */
data "aws_acm_certificate" "domain" {
  domain   = "*.catosplace.biz"
  statuses = ["ISSUED"]
}

/* Jenkins ALB */
/*
resource "aws_alb" "jenkins" {
  name            = "jenkins-alb"
  internal        = false
  subnets         = ["${module.vpc.public_subnets}"]
}
*/

/* Jenkins ALB HTTPS Listener */
resource "aws_alb_listener" "jenkins-https" {
  load_balancer_arn = "${module.ecs_alb.alb_arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${data.aws_acm_certificate.domain.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.jenkins.arn}"
    type             = "forward"
  }
}

/* Jenkins Service */
resource "aws_ecs_service" "jenkins-alb" {
  name            = "jenkins-alb"
  cluster         = "${module.ecs_prod_cluster.cluster_id}"
  task_definition = "${aws_ecs_task_definition.jenkins.arn}"
  desired_count   = 1
  iam_role        = "${module.ecs_prod_cluster.ecs_service_role_arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.jenkins.arn}"
    container_name   = "jenkins"
    container_port   = 8080
  }
}

/* Jenkins Task Definition */
resource "aws_ecs_task_definition" "jenkins" {
  family                = "jenkins"
  container_definitions = "${data.template_file.jenkins_task.rendered}"

  depends_on            = ["aws_cloudwatch_log_group.jenkins"]
}

/* Add CloudWatch log group */
resource "aws_cloudwatch_log_group" "jenkins" {
  name = "awslogs-jenkins"
}

/* Route53 */
resource "aws_route53_record" "www" {
  zone_id = "${var.hosted_zone_id}"
  name    = "sandbox.catosplace.biz"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.ecs_alb.dns_name}"]
}
