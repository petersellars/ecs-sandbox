# Terraform variables
# terraform.tfvars is picked up by defaulti

# VPC
#vpc = "vpc-deea28bb"
vpc = "vpc-c78c48a3"

# Security Groups (Comma Seperated)
#security_group_ids = "sg-01ab1864"
security_group_ids = "sg-b3709ed4"
availability_zones = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
#subnet_ids = "subnet-a479bed3,subnet-45e43d20,subnet-dbf5a49d"
subnet_ids = "subnet-cbe63992,subnet-5556fe23,subnet-b9af2cdd"

# ECS Cluster Name
ecs_cluster_name = "test-ecs-cluster"
