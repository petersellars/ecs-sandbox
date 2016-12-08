/* Jenkins ELB */
resource "aws_elb" "jenkins-elb" {
  name               = "jenkins-elb"
  internal           = false
  availability_zones = ["${split(",", var.availability_zones)}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "http:8080/"
    interval            = 30
  }

  connection_draining = false

  tags {
    Name = "jenkins-alb"
  }

}

/* Jenkins Service */
resource "aws_ecs_service" "jenkins-elb" {
  name            = "jenkins-elb"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.jenkins.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"
  depends_on      = ["aws_iam_role_policy.ecs_service_role_policy"]

  load_balancer {
    elb_name       = "${aws_elb.jenkins-elb.id}"
    container_name = "jenkins"
    container_port = 8080
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
