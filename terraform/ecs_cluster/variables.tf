variable "name" {
  description = "Name of the ECS cluster"
}

variable "environment" {
  description = "Environment label"
}

variable "vpc_id" {
  description = "VPC in which to create the cluster"
}

variable "registry" {
  description = "ECS Config Registry locator"
}

variable "image_id" {
  description = "AMI image ID for use in launch configuration"
}

variable "instance_type" {
  default     = "t2.medium"
  description = "AWS instance type"
}

variable "ecs_engine_auth" {
  description = "Authorisation token for ECS engine"
}

variable "s3_bucket_name" {
  description = "ECS configuration S3 bucket name"
}

variable "key_name" {
  description = "AWS SSH Key Name"
}

variable "key_file" {
  description = "AWS SSH Public Key file"
}


/* Autoscaling Group */
variable "availability_zones" {
  description = "Availability Zones to be used by autoscaling group"
  default     = []
}

variable "vpc_zone_identifier" {
  description = "Private subnets to be used by the autoscaling group"
  default     = []
}

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
