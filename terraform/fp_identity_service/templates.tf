/* Task Container Definitions */
data "template_file" "task_definition" {
  template = "${file("${path.module}/task-definitions/${var.name}.json")}"
 
  vars {
    name                     = "${var.name}"
    image                    = "${var.image}"
    port                     = "${var.port}"
    environment              = "${var.environment}"
    db_username              = "${aws_db_instance.service.username}"
    db_password              = "${var.db_password}"
    db_address               = "${aws_db_instance.service.address}"
    db_name                  = "${aws_db_instance.service.name}"
    default_domain           = "${var.default_domain}"
    log_level                = "${var.log_level}"
    rails_env                = "${var.rails_env}"
    token_iss                = "${var.token_iss}"
    identity_jwt_private_key = "${var.identity_jwt_private_key}"
    identity_jwt_public_key  = "${var.identity_jwt_public_key}"
    aes_iv                   = "${var.aes_iv}"
    aes_key                  = "${var.aes_key}"
    secret_key_base          = "${var.secret_key_base}"
  }
}
