/* Jenkins Target Group for use with ALB */
resource "aws_alb_target_group" "jenkins" {
  name     = "jenkins-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    port                = 8080
    interval            = 30
  }

}

/* Jenkins ALB */
resource "aws_alb" "jenkins" {
  name            = "jenkins-alb"
  internal        = false
  subnets         = ["${split(",", var.subnet_ids)}"]
}

/* Jenkins ALB Listener */
resource "aws_alb_listener" "jenkins" {
  load_balancer_arn = "${aws_alb.jenkins.arn}"
  port              = "80"

  default_action {
    target_group_arn = "${aws_alb_target_group.jenkins.arn}"
    type             = "forward"
  }

}

/* Jenkins Service */
resource "aws_ecs_service" "jenkins-elb" {
  name            = "jenkins-elb"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.jenkins.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.jenkins.arn}"
    container_name   = "jenkins"
    container_port   = 8080
  }

  depends_on      = ["aws_iam_role_policy.ecs_service_role_policy"]
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
