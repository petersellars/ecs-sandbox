# Terraform AWS ECS
This repo contains a [Terraform](https://www.terraform.io/) plan to run up an
[Amazon ECS](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
cluster.

## What It Does
* Builds an [Amazon VPC](https://aws.amazon.com/vpc/) with both a public and
private subnet. The ECS cluster is hosted in the private subnet with a bastion
server hosted in the private subnet.
* Creates an [VPC NAT Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html)
that enables containers in the ECS Cluster to connect to the internet and other
AWS Services.
* Creates an [VPC Internet Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Internet_Gateway.html)
that enables communication between private subnet instances and the internet.
* Creates [VPC Route Tables](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Route_Tables.html)
that enables incoming requests to route through the NAT Gateway to the ECS
Cluster in the private subnet and other AWS services.
* Creates an [Amazon ECS Cluster](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_clusters.html) in the private subnet of the VPC using an Auto-Scaling group configuration.
* Creates routing rules to enable access to RDS instances and containers through
the ALB.
* Sets up and populates an S3 bucket with the ECS Container Agent configuration.
* Adds the [awslogs Log Driver](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html)
to the Container Instances for both instance monitoring and container monitoring.
* Creates an [Application Load Balancer (ALB)](https://aws.amazon.com/elasticloadbalancing/applicationloadbalancer/) and associates it with the public subnet so that it can be accessed via the Internet Gateway.
* Creates the services needed within the ECS Cluster
  * Generates the [Amazon ECS Task Definition](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_defintions.html)
for the service using a combination of environment and terraform variables
  * Creates the [ECS Service](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html) that utilises the Task Definition generated.
  * Adds the [awslogs Log Driver](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html) to the container as part of the Task Definition.
  * Creates the [Amazon RDS](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)
instance required by a Service.

## Prerequisites
* An [AWS account](http://aws.amazon.com/)
  * You will need to know some of the details and have administrator rights to
    set up some user privileges
  * A user set up with the permissions outlined [here](#terraform-user-aws-ecs-key-pair)
* Terraform installed, recommended (>=0.6.3). Head over to https://www.terraform.io/downloads.html
to grab the latest version
  * __Tested on 0.7.13 - Terraform 0.8.0 add breaking changes!__
* A Ruby environment set up for writing and running [awspec](https://github.com/k1LoW/awspec) 
tests
  * Recommendation - [rbenv](https://github.com/rbenv/rbenv)

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

[4] Get the Local Terraform Modules
In order to run the plan you will need to import the local Terraform modules
used by this repository. Simply run:
```
terraform get
```

[5] Check and Run the plan:
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
[6] Run the tests
Ensure the `spec/cluster_config.rb` variables are what is expected. These
should match your `terraform.tfvars`.

[7] Tear down the resources
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
AWSCertificateManagerReadOnly, AmazonRoute53FullAccess, AmazonRDSFullAccess
and IAMFullAccess permissions. The user does not need console access.

Create a Key Pair for use with the Terraform plan. Name it `devops-ecs` and
store the .pem file in a secure location.
