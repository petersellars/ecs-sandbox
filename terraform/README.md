# Terraform AWS ECS
This repo contains a [Terraform](https://www.terraform.io/) plan to run up an
[Amazon ECS](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
cluster.

## Prerequisites
* An AWS account http://aws.amazon.com/
* Terraform installed, recommended (>=0.6.3). Head over to https://www.terraform.io/downloads.html
to grab the latest version
* A Ruby environment set up for writing and running [awspec](https://github.com/k1LoW/awspec) 
tests

## Usage
[1] Clone the repo

[2] Set the required variables:
```
export TF_VAR_key_name=devops-ecs
export TF_VAR_key_file=~/.ssh/devops-ecs.pub
export TF_VAR_aws_access_key="AWS_ACCESS_KEY_ID"
export TF_VAR_aws_secret_key="AWS_SECRET_KEY"
export TF_VAR_ecs_engine_auth="DOCKERHUB_AUTH_TOKEN"
```
[3] Set the cluster variables:
Create a cluster.tfvars file based on the `terraform.tfvars` and set your
cluster variables. The specifications will need to be changed/added based on
your variables. Remember to use the variables with the Terraform commands
using the `-var-file=cluster.tfvars` format.

[4] Check and Run the plan:
With the default variables in `terraform.tfvars`
```
terraform plan
terraform apply 
```
With cluster specific variables in `cluster.tfvars`
```
terraform plan -var-file=cluster.tfvars
terraform apply -var-file=cluster.tfvars
```
[5] Run the tests
Ensure the `spec/cluster_config.rb` variables are what is expected. These
should match your `terraform.tfvars`.

[6] Tear down the resources
Terraform can remove all the resources added.

With the default variables
```
terraform destroy
```
With cluster specific variables
```
terraform destroy -var-files=cluster.tfvars
```

## Linting/Styling
This repo uses [Rubocop](http://rubocop.readthedocs.io/en/latest/) for static
code analysis. This will enforce guidelines outlined in the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide).
A configuration file [./.rubocop.yml] can be found in the root directory. To
run rubocop you will need to execute:
```
bundle exec rubocop
```

## Testing and TDD
This repo uses [awspec](https://github.com/k1LoW/awspec) to test AWS resources.
In order to run the tests you will need a Ruby environment set up and an AWS
credentials file `~/.aws/credentials`.

To run the tests
```
AWS_PROFILE=terraform_ecs bundle exec rake spec
```

### Terraform User & AWS ECS Key Pair
Set up an AWS user called `terraform_ecs` with  AmazonEC2FullAccess, 
AmazonEC2ContainerServiceFullAccess, AmazonS3FullAccess, CloudWatchFullAccess 
and IAMFullAccess permissions. The user does not need console access.

Create a Key Pair for use with the Terraform plan. Name it `devops-ecs` and
store the .pem file in a secure location.
