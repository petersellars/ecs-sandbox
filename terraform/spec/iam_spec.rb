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
