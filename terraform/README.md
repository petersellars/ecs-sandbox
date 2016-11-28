# Terraform AWS ECS
This repo contains a [Terraform](https://www.terraform.io/) plan to run up an
[Amazon ECS](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
cluster.

## Prerequisites
* An AWS account http://aws.amazon.com/
* Terraform installed, recommended (>=0.6.3). Head over to https://www.terraform.io/downloads.html
to grab the latest version

## Usage
1. Clone the repo
2. Set the required variables:
```
export TF_VAR_key_name=devops-ecs
export TF_VAR_key_file=~/.ssh/devops-ecs.pem
export TF_VAR_aws_access_key="AWS_ACCESS_KEY_ID"
export TF_VAR_aws_secret_key="AWS_SECRET_KEY"
```
3. Check and Run the plan:
```
terraform plan
terraform apply 
```

### Terraform User & AWS ECS Key Pair
Set up an AWS user called `terraform_ecs` with  AmazonEC2FullAccess and 
AmazonEC2ContainerServiceFullAccess permissions. The user does not need console
access.

Create a Key Pair for use with the Terraform plan. Name it `devops-ecs` and
store the .pem file in a secure location.
