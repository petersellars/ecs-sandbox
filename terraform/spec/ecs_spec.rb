require 'spec_helper'
require 'cluster_config'

describe ecs_cluster do
  include_context 'aws_config'
  include_context 'cluster_config'

  subject do
    Awspec::Type::EcsCluster.new(display_name)
  end

  describe 'ecs-cluster' do
    let(:display_name) { cluster_name }

    it { should exist }
    it { should be_active }
    it { should_not be_inactive }

    its(:status) { should eq 'ACTIVE' }
    its(:cluster_name) { should eq cluster_name }
    its(:cluster_arn) { should eq "arn:aws:ecs:#{aws_region}:#{aws_account}:cluster/#{cluster_name}" }
    its(:registered_container_instances_count) { should eq 1 }
    its(:running_tasks_count) { should eq 1 }
    its(:pending_tasks_count) { should eq 0 }
    its(:active_services_count) { should eq 1 }
  end
end
