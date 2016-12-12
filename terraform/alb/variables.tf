variable "name" {
  description = "Name of the Application Load Balancer"
}

variable "internal" {
  description = "Should this Application Load Balancer be internal"
  default     = false
}

variable "vpc_id" {
  description = "VPC that the Application Load Balancer should sit target"
}

variable "subnets" {
  description = "List of subnet IDs to attach to the Application Load Balancer"
  default     = []
}

variable "target_group" {
  description = "Default Target Group name"
}

variable "certificate_domain" {
  description = "Domain to check for ACM certificate for HTTPS Listener use"
}
