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

/* All availability zones must be within a region */
variable "availability_zones" {
  description = "Comma seperated list of EC2 availability zones to launch instances in"
  default     = ""
}

variable "private_subnets" {
  description = "Private VPC Subnets"
  default     = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
}

variable "public_subnets" {
  description = "Public VPC Subnets"
  default     = ["10.10.101.0/24","10.10.102.0/24","10.10.103.0/24"]
}

variable "vpc" {
  description = "VPC used"
  default     = ""
}

variable "subnet_ids" {
  description = "Comma seperated list of subnet ids, must match availability zones"
  default     = ""
}

variable "security_group_ids" {
  description = "Comma seperated list of security group ids"
  default     = ""
}

variable "ecs_cluster_name" {
  description = "Name of the Amazon ECS cluster"
  default     = "default"
}

variable "s3_bucket_name" {
  description = "Name of the S3 configuration bucket"
  default     = "lic-ecs"
}

variable "jenkins_docker_image" {
  description = "Jenkins Docker image to use"
  default     = "cato1971/docker-jenkins:latest"
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

/* Autoscaling Group */
variable "min_size" {
  description = "Minimum number of instances to run in the autoscaling group"
  default     = "1"
}

variable "max_size" {
  description = "Maximum number of instances to run in the group"
  default     = "5"
}

variable "desired_capacity" {
  description = "Desired number of instances to run in the group"
  default     = "1"
}
