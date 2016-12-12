variable "name" {
  description = "VPC name"
}

variable "cidr" {
  description = "CIDR block associated with the VPC"
}

variable "public_subnets" {
  description = "List of public subnets inside the VPC"
  default     = []
}

variable "private_subnets" {
  description = "List of private subnets inside the VPC"
  default     = []
}

variable "availability_zones" {
  description = "List of Availability zones in the region"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Should private DNS be used within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Should private DNS be used within the VPC"
  default     = false
}

variable "enable_nat_gateway" {
  description = "Should NAT Gateways be provisioned for each private network"
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "Should we auto-assign a public IP on launch"
  default     = true
}

variable "private_propagating_vgws" {
  description = "List of VGWs the private route table should propagate"
  default     = []
}

variable "public_propagating_vgws" {
  description = "List of VGWs the public route table should propagate"
  default     = []
}
