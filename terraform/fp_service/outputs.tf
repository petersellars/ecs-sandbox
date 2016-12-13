output "rds_instance_id" {
  value = "${aws_db_instance.service.rds_instance_id}"
}

output "rds_instance_address" {
  value = "${aws_db_instance.service.rds_instance_address}"
}
