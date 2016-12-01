require 'spec_helper'
require 'cluster_config'

describe autoscaling_group do
  include_context 'cluster_config'

  subject do
    Awspec::Type::AutoscalingGroup.new(display_name)
  end

  describe 'ecs-asg' do
    let(:display_name) { 'ecs-asg' }

    it { should exist }
    its(:desired_capacity) { should eq 1 }
    its(:min_size) { should eq 1 }
    its(:max_size) { should eq 5 }
    its(:launch_configuration_name) { should eq launch_configuration }
    
  end
end
