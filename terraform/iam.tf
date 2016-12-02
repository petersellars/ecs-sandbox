/* ECS IAM Role and Policies */

/* ECS Container Instance Role */
resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs_instance_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

/* ECS Container Instance Role & Policy */
resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name     = "ecs_instance_role_policy"
  policy   = "${file("policies/ecs-instance-role-policy.json")}"
  role     = "${aws_iam_role.ecs_instance_role.id}"
}

/* ECS Service Scheduler Role */
resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

/* ECS Service Scheduler Role & Policy */
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name     = "ecs_service_role_policy"
  policy   = "${file("policies/ecs-service-role-policy.json")}"
  role     = "${aws_iam_role.ecs_service_role.id}"
}

/* IAM profile to be used in auto-scaling launch configuration */
resource "aws_iam_instance_profile" "ecs" {
  name  = "ecs_instance_profile"
  path  = "/"
  roles = ["${aws_iam_role.ecs_instance_role.name}"]
}

/* ECS CloudWatch Logs IAM Policy */
resource "aws_iam_policy" "ecs_cloudwatch_logs" {
  name        = "ecs_cloudwatch_logs"
  description = "ECS CloudWatch Logs Policy"
  policy      = "${file("policies/ecs-cloudwatch-logs-policy.json")}"
}

/* Attach ECS CloudWatch Logs Policy */
resource "aws_iam_policy_attachment" "ecs" {
  name       = "ecs_cloudwatch_logs"
  roles      = ["${aws_iam_role.ecs_instance_role.name}"]
  policy_arn = "${aws_iam_policy.ecs_cloudwatch_logs.arn}"
}
