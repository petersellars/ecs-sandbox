output "dns_name" {
  value = "${aws_alb.mod.dns_name}"
}

output "alb_arn" {
  value = "${aws_alb.mod.arn}"
}
