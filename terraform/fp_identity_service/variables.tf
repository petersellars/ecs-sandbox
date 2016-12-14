variable "name" {
  description = "Service Name"
}

variable "environment" {
  description = "Environment label"
}

/** Environment Variables **/
variable "aes_iv" {
}

variable "aes_key" {
}

variable "identity_jwt_private_key" {
}

variable "identity_jwt_public_key" {
}

variable "secret_key_base" {
}

variable "default_domain" {
}

variable "log_level" {
}

variable "rails_env" {
}

variable "token_iss" {
}

variable "family" {
  description = "Task Definition Family Name "
}

variable "image" {
  description = "Docker Image to be used by the Service"
}

variable "vpc_id" {
  description = "VPC to create resources in"
}

variable "hc_path" {
  decription = "Health check path"
  default    = "/"
}

variable "port" {
  description = "Port used by Image"
}

variable "db_password" {
  description = "DB Password to set for RDS instance"
}

variable "private_subnets" {
  description = "Private Subnets for RDS instances"
  default     = []
}

variable "rds_ecs_sg_id" {
  description = "RDS ECS Access Security Group to add to RDS instance"
}

variable "cluster_id" {
  description = "ECS Cluster to deploy service into"
}

variable "load_balancer" {
  description = "Application Load Balancer to add Service to"
}

variable "load_balancer_dns_name" {
  description = "Application Load Balancer to add to DNS"
}

variable "ecs_service_role" {
  description = "IAM ECS Service Role" 
}

variable "certificate_domain" {
  description = "Domain to check for ACM certificate for HTTPS Listener use"
}

