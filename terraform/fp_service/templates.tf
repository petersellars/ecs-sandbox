/* Task Container Definitions */
data "template_file" "task_definition" {
  template = "${file("${path.module}/task-definitions/${var.name}.json")}"
 
  vars {
    name        = "${var.name}"
    image       = "${var.image}"
    port        = "${var.port}"
    environment = "${var.environment}"
    db_username = "${aws_db_instance.service.username}"
    db_password = "${var.db_password}"
    db_address  = "${aws_db_instance.service.address}"
    db_name     = "${aws_db_instance.service.name}"
  }
}

data "template_file" "identity_service_task_definition" {
  template = "${file("${path.module}/task-definitions/${var.name}.json")}"

  vars {
    name        = "${var.name}"
    image       = "${var.image}"
    port        = "${var.port}"
    environment = "${var.environment}"
    db_username = "${aws_db_instance.service.username}"
    db_password = "${var.db_password}"
    db_address  = "${aws_db_instance.service.address}"
    db_name     = "${aws_db_instance.service.name}"
  }
}
