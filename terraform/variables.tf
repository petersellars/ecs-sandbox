variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "key_name" {
  description = "AWS SSH Key Name"
}

variable "key_file" {
  description = "AWS SSH Public Key file"
} 

variable "ecs_engine_auth" {
  description = "ECS Engine Auth Token"
}

variable "region" {
  description = "AWS region to create resources in"
  default     = "ap-southeast-2"
}

/* ECS optimized AMIs per region */
variable "amis" {
  /* version 2016.09 */
  type = "map"
  default = {
    ap-southeast-1 = "ami-a900a3ca"
    ap-southeast-2 = "ami-5781be34"
  }
}

variable "ami" {
/* Unable to interpolate here!!!! */
#  default     = "${lookup(var.amis, var.region)}"
  default     = "ami-5781be34"
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "instance_type" {
  default     = "t2.medium"
  description = "AWS instance type"
}

variable "hosted_zone_id" {
  description = "Hosted zone to add DNS record to"
}

/* IDENTITY SERVICE */

variable "identity_db_password" {
  description = "Identity Service DB Password"
}

variable "aes_key" {
  default = ""
}

variable "identity_jwt_private_key" {
  default = ""
}

variable "identity_jwt_public_key" {
  default = ""
}

variable "aes_iv" {
  default = ""
}

variable "secret_key_base" {

}
