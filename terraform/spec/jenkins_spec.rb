require 'spec_helper'

describe ecs_task_definition('jenkins') do
  it { should exist }
  it { should be_active }

  its(:status) { should eq 'ACTIVE' }
  its(:family) { should eq 'jenkins' }
end

# Need to add cluster to ecs_service in awsspec
=begin
describe ecs_service('jenkins-elb') do
  it { should exist }
  it { should be_active }
  it { should_not be_draining }

  its(:status) { should eq 'ACTIVE' }
  its(:service_name) { should eq 'jenkins-elb' }
  its(:desired_count) { should eq 1 }
  its(:pending_count) { should eq 0 }
  its(:running_count) { should eq 1 }
end
=end

describe ecs_service do
  subject do
    Awspec::Type::EcsService.new(display_name)
  end

  describe 'ecs_service' do
    let(:display_name) { 'jenkins-elb' }
    let(:cluster_name) { 'test-ecs-cluster' }

    it { should exist }
  end
end
