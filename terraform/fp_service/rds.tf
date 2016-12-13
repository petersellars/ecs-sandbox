/* Service DB Subnet Group */
resource "aws_db_subnet_group" "service" {
  name       = "service_db_subnet_group"
  subnet_ids = ["${var.private_subnets}"]

  tags {
    Environments = "${var.environment}"
  }
}

/* Service Database */
resource "aws_db_instance" "service" {
  allocated_storage       = "50"
  engine                  = "postgres"
  engine_version          = "9.5.4"
  instance_class          = "db.t2.medium"
  identifier              = "${lower(var.name)}-${lower(var.environment)}"
  name                    = "identitydb"
  username                = "identitydbuser"
  password                = "${var.db_password}"
  db_subnet_group_name    = "${aws_db_subnet_group.service.name}"
  backup_retention_period = "7"
  backup_window           = "18:19-18:49"

  tags {
    workload-type = "${var.environment}"
  }

}
