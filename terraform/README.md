# Terraform AWS ECS
This repo contains a [Terraform](https://www.terraform.io/) plan to run up an
[Amazon ECS](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
cluster.

It utilises [Terraform Modules](https://www.terraform.io/docs/modules/index.html) 
to create the [VPC](./vpc), [Application Load Balancer (ALB)](./alb), [ECS_Cluster](./ecs_cluster),
[Bastion Host](./bastion) and services. There is a [template service](./fp_service)
included in this repository. Services should use this as a basis with specific
service configurations made in the a service specific module.

| Module | Location     | Description |
| ------ | ------------ | ----------- |
| alb | [alb](./alb) | Creates an Application Load Balancer (ALB) for use with ECS Services |
| bastion | [bastion](./bastion) | Creates a Bastion Host to enable access into Private Subnet |
| ecs_cluster | [ecs_cluster](./ecs_cluster) | Creates an ECS Cluster ready to deploy Services |
| fp_service | [fp_service](./fp_service) | Template Service Module - use to build concrete Service Modules|
| vpc | [vpc](./vpc) | Creates a VPC with Private and Public Subnets |


At this time it only support the [AWS Provider](https://www.terraform.io/docs/providers/aws/index.html) as it is specifically targeted at [Amazon ECS](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html). The [main.tf](./main.tf) contains the main configuration and utilises both secret variables and the [terraform.tfvars](./terraform.tfvars) variables to plan and apply infrastructure changes.

---

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
* Creates a [Bastion Host](https://en.wikipedia.org/wiki/Bastion_host) that
enables connection to hosts inside the Private Subnet.
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

---

## Prerequisites
* An [AWS account](http://aws.amazon.com/)
  * You will need to know some of the details and have administrator rights to
    set up some user privileges
  * A user set up with the permissions outlined [here](#terraform-user-aws-ecs-key-pair)
  * A generated key-pair with both a public and private key for use in EC2 container instance use
* An AWS Registered Domain name in order to [Generate SSL Certificates](Generate SSL Certificates)
* Terraform installed, recommended (>=0.6.3). Head over to https://www.terraform.io/downloads.html
to grab the latest version
  * __Tested on 0.7.13 - Terraform 0.8.0 add breaking changes!__
* A Ruby environment set up for writing and running [awspec](https://github.com/k1LoW/awspec) 
tests
  * Recommendation - [rbenv](https://github.com/rbenv/rbenv)

---

## Getting Started

1. [Clone the repo](#clone-the-repo)
2. [Set the Secrets](#set-the-secrets) 
3. [Set the Cluster Variables](#set-the-cluster-variables)
4. [Get the Local Terraform Modules](#get-the-local-terraform-modules)
5. [Check and apply the plan](#check-and-apply-the-plan)
6. Run the tests

#### Clone the repo
Clone this repository locally or onto a build server
```
git clone git@gitlab.com:lic-nz/infrastructure.git
```
Change directory into the cloned repository. Change into the terraform
directory.
```
cd infrastructure/farm-performance/terraform
```

#### Set the Secrets
Secrets need to be set either as environment variables or via a `.tfvars` file
that is not commited to source control. The secrets discussed here are at the
repository level. Service secrets should be added to these based on the specific
service needs.

| Secret | Description |
| ------ | ----------- |
| key_name | The name of the Key Pair created for each EC2 Instance |
| key_file | The public key associated with the Key Pair for each EC2 Instance |
| aws_access_key | The AWS Access Key ID for the user applying the plan |
| aws_secret_key | The AWS Secret Key for the user applying the plan |
| ecs_engine_auth | The Engine Auth Token for the ECS Container Agent to pull containers |

###### Setting Secrets via Environment Variables
These values can be set as environment variables on the machine where the plan
will be applied from.
```
export TF_VAR_key_name=devops-ecs
export TF_VAR_key_file=~/.ssh/devops-ecs.pub
export TF_VAR_aws_access_key="AWS_ACCESS_KEY_ID"
export TF_VAR_aws_secret_key="AWS_SECRET_KEY"
export TF_VAR_ecs_engine_auth="GITLAB_AUTH_TOKEN"
```

###### Setting the Secrets in a `.tfvars` file
These values can also be set in a `.tfvars` file. This file should not be
committed to source control and it is a good idea to add it to the .gitignore
file.
```
key_name = "devops_ecs"
key_file = "~/.ssh/devops_ecs.pub"
aws_access_key = "AWS_ACCESS_KEY_ID"
aws_secret_key = "AWS_SECRET_KEY"
ecs_engine_auth = "GITLAB_AUTH_TOKEN"
```

#### Set the Cluster Variables
By default Terraform will use the [terraform.tfvars](./terraform.tfvars)
variable file. You can either add Cluster Variables to this file or create
specific Cluster Variable files. Creating a file per cluster based on the
concepts of environments could be beneficial.

| Cluster Variable | Description |
| ---------------- | ----------- |
| hosted_zone_id | Route 53 Hosted Zone to associate the ECS Cluster with |

__TODO__: Refactor the Cluster variables out of `main.tf` to make this useful!

If you use an additional variables file be sure to use `-var-file=XXX.tfvars`
when running Terraform commands.

#### Get the Local Terraform Modules
In order to run the plan you will need to import the local Terraform modules
used by this repository. Run the Terraform `get` command to import the modules
into the local `.terraform` directory.
```
terraform get
```
This will import the following local modules at this time [alb](./alb), 
[bastion](./bastion), [ecs_cluster](./ecs_cluster) and [vpc](./vpc). It will
also import any specific service modules created and present in [main.tf](./main.tf)

#### Check and Apply the plan
This section assumes you just want to check and apply the plan. Development and
changes to the plan require a different workflow. You may want to check and run
a plan to stand up a new cluster or to deploy a new version of a resource to an
existing cluster. Checking and running the plan is a two step process. Step one
validates the plan and step two applies the plan.

###### Checking the Plan
Checking the plan entails running Terraforms `plan` command that will check the
known state against the current implementation of the infrastructure. It will
display additions, updates and removals of resources based on the plan and state.
Secrets will need to be passed either via environment variables or via a secrets
file that is not committed to source control.

With the default Cluster variables:
```
terraform plan -var-file=secrets.tfvars
```
With Cluster specific variables in `cluster.tfvars`:
```
terraform plan -var-file=secrets.tfvars -var-file=cluster.tfvars
```
Example of plan output
```
~ module.fp-identity-service.aws_ecs_service.mod
    task_definition: "arn:aws:ecs:ap-southeast-2:459425154642:task-definition/identity-service:27" => "<computed>"

-/+ module.fp-identity-service.aws_ecs_task_definition.mod
    arn:                   "arn:aws:ecs:ap-southeast-2:459425154642:task-definition/identity-service:27" => "<computed>"
    container_definitions: "20a2647aadb14e318329c39945bf00447bc3b376" => "e23d0c5160d733731933b6e7cf75c7b4f19df802" (forces new resource)
    family:                "identity-service" => "identity-service"
    network_mode:          "" => "<computed>"
    revision:              "27" => "<computed>"
```
Check that the plan is going to make the changes you expected. Once you are
happy with the plan you can apply it. You could also check the plan and output
it to a file and apply against the plan. Any plans saved will apply exactly the
changes you originally saw but be aware that these plans are likely to contain
secrets so should be encrypyted if you store them for any length of time.

###### Applying the Plan
Once you are happy with the plan it is time to apply it. Applying the plan will
execute the changes into the targeted environment. Once applied the state will
be updated to reflect the changes made so future plans will only report on the
changes to be made. Once more secrets will need to be passed either via
environment variables or via a secrets file that is not committed to source
control.

With the default Cluster variables:
```
terraform apply -var-file=secrets.tfvars
```
With Cluster specific variables in `cluster.tfvars`:
```
terraform apply -var-file=secrets.tfvars -var-file=cluster.tfvars
```
Example of apply output
```
Apply complete! Resources 2 added, 1 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

  vpc_id = vpc-ec34d3df
```
Once the plan has been applied Terraform will report on the outcome and the
changes will have been made to both the infrastructure and the state file. You
can inspect the current state by using the `terraform show` command. The `show`
command will output secrets too so it is important not to save the output or
store it for any length of time.

#### Run the tests
Ensure the `spec/cluster_config.rb` variables are what is expected. These
should match your `terraform.tfvars`.

---

## Bastion Host
A [Bastion Host](https://en.wikipedia.org/wiki/Bastion_host) with access to the 
Private Subnet is created by the default Terraform plan. The Bastion has only
port 22 open for connection. To connect to the Bastion you will need the private
key associated with your instance during creation or stored in the S3 bucket
used by the Bastion to establish authorized users. The Bastion host is set up
to poll for keys in a configuration bucket, so users can be added by placing
their public keys into this bucket.

### Connecting to the Bastion Host
In order to connect to the Bastion you will need a private key associated with
any of the public keys authorized on the Bastion host and know the Bastion host
IP address. 
```
ssh -i ~/.ssh/XXXX.pem ubuntu@<bastion-host-public-ip>
```

### Connecting to Container Instances from the Bastion Host 
Connecting to Container Instances from the Bastion Host is best achieved using
SSH Agent forwarding from your local instance. To do this you will need to add
the relevant key/s to your SSH Agent using `ssh-add ~/.ssh/XXXX.pem`. You will
need the private key for the Container Instances for this process. To use these
keys to connect to the Container Instances log on to the Bastion host with SSH
forwarding enabled.
```
ssh -A -i ~/.ssh/XXXX.pem ubuntu@<bastion-host-public-ip>
```
From the Bastion you should now be able to connect to the Container Instance. You
will need to know the private IP address of the Container Instance at this point.
```
ssh ec2-user@<container-instance-private-ip>
```

---

## Tear down the resources
Terraform can remove all the resources added using the `destroy` command based
on the current state.

With the default Cluster variables
```
terraform destroy -var-file=secrets.tfvars
```
With cluster specific variables
```
terraform destroy -var-file=secrets.tfvars -var-files=cluster.tfvars
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

---

### Terraform ECS User 
Set up an AWS user called `terraform_ecs` with the following permissions

| Permission |
| ---------- |
| AmazonEC2FullAccess|
| AmazonEC2ContainerServiceFullAccess |
| AmazonS3FullAccess |
| CloudWatchFullAccess |
| AWSCertificateManagerReadOnly |
| AmazonRoute53FullAccess |
| AmazonRDSFullAccess |
| IAMFullAccess |

The user does not need console access.

### ECS Key Pair

A Key Pair is required for use in the Terraform plan. This Key Pair is installed
on the Container instances and the Bastion Host by default. By default it should
be named `devops-ecs`. Store the public and private key files in a secure 
location.

---

### Generate SSL Certificates 
In order to route traffic over HTTPS to the Application Load Balancer (ALB) an
SSL Certificate needs to be obtained, associated with the relevant domain and
attached to the ALB. The easiest way to do this for domains registered with AWS
is via the [AWS Certificate Manager](https://aws.amazon.com/certificate-manager/).

Creation of the Certificate requires an AWS registered Domain. [Requesting a Certficate](http://docs.aws.amazon.com/acm/latest/userguide/gs-acm.html)
is a manual process requiring someone to validate Domain Ownership. Once Domain
Ownership has been validated the certificate can be used by the Terraform plan
when creating an SSL ALB.
