/**
 * Provides internal access to container ports
 */
resource "aws_security_group" "ecs" {
  name        = "ecs-sg"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${var.vpc_id}"  

  ingress {
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ecs-sg"
  }
}

/**
 * Provides HTTPS access to the ALB
 */
resource "aws_security_group" "ecs_vpc" {
  name        = "allow_https"
  description = "Allow https traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_https"
  }
}
