variable "name" {
  description = "Name of the Application Load Balancer"
}

variable "vpc_id" {
  description = "VPC to place ALB Resources"
}

variable "vpc_default_security_group_id" {
  description = "Default VPC Security Group"
}

variable "environment" {
  description = "Environment label"
}

variable "internal" {
  description = "Should this Application Load Balancer be internal"
  default     = false
}

variable "subnets" {
  description = "List of subnet IDs to attach to the Application Load Balancer"
  default     = []
}
