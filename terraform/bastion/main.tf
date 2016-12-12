resource "aws_instance" "bastion" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  user_data              = "${template_file.user_data.rendered}"

  count                  = 1

  tags {
    Name = "${var.name}"
  }
}
