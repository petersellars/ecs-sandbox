/* Application Load Balancer */
resource "aws_alb" "mod" {
  name     = "${var.name}"
  internal = "${var.internal}"
  subnets  = ["${var.subnets}"]
}
