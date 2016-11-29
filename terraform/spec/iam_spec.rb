require 'spec_helper'

describe iam_role('ecs_instance_role') do
  it { should exist }
  it { should have_inline_policy('ecs_instance_role_policy') }
end

describe iam_role('ecs_instance_role') do
  it { should be_allowed_action('ecs:CreateCluster') }
  it { should be_allowed_action('ecs:DeregisterContainerInstance') }
  it { should be_allowed_action('ecs:DiscoverPollEndpoint') }
  it { should be_allowed_action('ecs:Poll') }
  it { should be_allowed_action('ecs:RegisterContainerInstance') }
  it { should be_allowed_action('ecs:StartTelemetrySession') }
  it { should be_allowed_action('ecs:Submit*') }
  it { should be_allowed_action('logs:CreateLogStream') }
  it { should be_allowed_action('logs:PutLogEvents') }
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
