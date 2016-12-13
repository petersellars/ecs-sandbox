variable "ssh_public_key_names" {
  default = "devops_ecs"
}

resource "aws_s3_bucket" "ssh_public_keys" {
  region = "${var.region}"
  bucket = "${var.s3_bucket_name}"
  acl    = "private"
  policy = <<EOF
{
	"Version": "2008-10-17",
	"Id": "Policy142469412148",
	"Statement": [
		{
			"Sid": "Stmt1424694110324",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::428447784580:root"
			},
			"Action": [
				"s3:List*",
				"s3:Get*"
			],
			"Resource": "arn:aws:s3:::fp-bastion-keys-bucket"
		}
	]
}
EOF
}

resource "aws_s3_bucket_object" "ssh_public_keys" {
  bucket     = "${aws_s3_bucket.ssh_public_keys.bucket}"
  key        = "${element(split(",", var.ssh_public_key_names), count.index)}.pub"

  # Make sure that you put files into correct location and name them accordingly (`public_keys/{keyname}.pub`)
  content    = "${file("${path.module}/public_keys/${element(split(",", var.ssh_public_key_names), count.index)}.pub")}"
  count      = "${length(split(",", var.ssh_public_key_names))}"

  depends_on = ["aws_s3_bucket.ssh_public_keys"]
}
