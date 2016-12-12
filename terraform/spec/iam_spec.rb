require 'spec_helper'

describe iam_role('ecs_instance_role') do
  it { should exist }
  it { should have_inline_policy('ecs_instance_role_policy') }
  it { should have_iam_policy('ecs_cloudwatch_logs') }
  it { should have_iam_policy('AmazonS3ReadOnlyAccess') }
end

describe iam_role('ecs_instance_role') do
  it { should be_allowed_action('ecs:CreateCluster') }
  it { should be_allowed_action('ecs:DeregisterContainerInstance') }
  it { should be_allowed_action('ecs:DiscoverPollEndpoint') }
  it { should be_allowed_action('ecs:Poll') }
  it { should be_allowed_action('ecs:RegisterContainerInstance') }
  it { should be_allowed_action('ecs:StartTelemetrySession') }
  it { should be_allowed_action('ecs:Submit*') }
  it { should be_allowed_action('logs:CreateLogGroup').resource_arn('arn:aws:logs:*:*:*') }
  it { should be_allowed_action('logs:CreateLogStream') }
  it { should be_allowed_action('logs:PutLogEvents') }
  it { should be_allowed_action('logs:DescribeLogStreams').resource_arn('arn:aws:logs:*:*:*') }
  it { should be_allowed_action('s3:Get*') }
  it { should be_allowed_action('s3:List*') }
end

describe iam_role('ecs_service_role') do
  it { should exist }
  it { should have_inline_policy('ecs_service_role_policy') }
end

describe iam_role('ecs_service_role') do
  it { should be_allowed_action('ec2:AuthorizeSecurityGroupIngress') }
  it { should be_allowed_action('ec2:Describe') }
  it { should be_allowed_action('elasticloadbalancing:DeregisterInstancesFromLoadBalancer') }
  it { should be_allowed_action('elasticloadbalancing:DeregisterTargets') }
  it { should be_allowed_action('elasticloadbalancing:Describe') }
  it { should be_allowed_action('elasticloadbalancing:RegisterInstancesWithLoadBalancer') }
  it { should be_allowed_action('elasticloadbalancing:RegisterTargets') }
end

describe iam_policy('ecs_cloudwatch_logs') do
  include_context 'aws_config'

  it { should exist }
  it { should be_attachable }
  it { should be_attached_to_role('ecs_instance_role') }

  its(:attachment_count) { should eq 1 }
  its(:arn) { should eq "arn:aws:iam::#{aws_account}:policy/ecs_cloudwatch_logs" }
  its(:policy_name) { should eq 'ecs_cloudwatch_logs' }
end
