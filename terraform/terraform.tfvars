# Terraform variables
# terraform.tfvars is picked up by default

# Security Groups (Comma Seperated)
security_group_ids = "sg-01ab1864"
availability_zones = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
subnet_ids = "subnet-a479bed3,subnet-45e43d20,subnet-dbf5a49d"

# ECS Cluster Name
ecs_cluster_name = "test-ecs-cluster"
