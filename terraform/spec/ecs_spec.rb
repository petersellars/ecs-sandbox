require 'spec_helper'
require 'test_config'

describe ecs_cluster('test-ecs-cluster') do
  include_context 'aws_config'

  it { should exist }
  it { should be_active }
  it { should_not be_inactive }
  its(:status) { should eq 'ACTIVE' }
  its(:cluster_name) { should eq 'test-ecs-cluster' }
  its(:cluster_arn) { should eq "arn:aws:ecs:#{aws_region}:#{aws_account}:cluster/test-ecs-cluster" }
  its(:registered_container_instances_count) { should eq 0 }
  its(:running_tasks_count) { should eq 0 }
  its(:pending_tasks_count) { should eq 0 }
  its(:active_services_count) { should eq 0 }
end
