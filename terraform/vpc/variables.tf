variable "name" {
  description = "VPC name"
}

variable "cidr" {
  description = "CIDR block associated with the VPC"
}

variable "enable_dns_hostnames" {
  description = "Should private DNS be used within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Should private DNS be used within the VPC"
  default     = false
}
