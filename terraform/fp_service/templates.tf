/* Task Container Definitions */
data "template_file" "task_definition" {
  template = "${file("${path.module}/task-definitions/${var.name}.json")}"
 
  vars {
    name        = "${var.name}"
    image       = "${var.image}"
    port        = "${var.port}"
    environment = "${var.environment}"
  }
}
