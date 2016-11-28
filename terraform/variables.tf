variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "region" {
  description = "AWS region to create resources in"
  default = "ap-southeast-2"
}

variable "key_name" {
  description = "AWS SSH Key Name"
  default = ""
}

variable "key_file" {
  description = "AWSH SSH Public Key file"
  default = ""
}
