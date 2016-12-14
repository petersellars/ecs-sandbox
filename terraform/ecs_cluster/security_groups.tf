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
 * Provides RDS access to the containers in ECS
 */
resource "aws_security_group" "ecs_rds" {
  name        = "rds-ecs"
  description = "RDS Port ingress from ECS SG"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "rds-ecs-sg"
  }
}
