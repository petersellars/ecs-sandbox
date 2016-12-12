require 'spec_helper'

describe launch_configuration do
  include_context 'aws_config'
  include_context 'cluster_config'

  subject do
    Awspec::Type::LaunchConfiguration.new(display_name)
  end

  describe 'ecs-launch-configuration' do
    let(:display_name) { launch_configuration }
    it { should exist }
    it { should have_security_group(ecs_security_group) }
    its(:launch_configuration_name) { should eq launch_configuration }
    its(:image_id) { should eq image_id }
    its(:instance_type) { should eq instance_type }
    its(:iam_instance_profile) { should eq 'ecs_instance_profile' }
    its(:key_name) { should eq key_name }
    # This is not stored as text!!!
    # its(:user_data) { should eq '#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.ecs.name} > /etc/ecs/ecs.config' }
  end
end
