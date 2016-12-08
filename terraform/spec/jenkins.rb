require 'spec_helper'

describe ecs_task_definition('jenkins') do
  it { should exist }
  it { should be_active }

  its(:status) { should eq 'ACTIVE' }
  its(:family) { should eq 'jenkins' }
end

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
