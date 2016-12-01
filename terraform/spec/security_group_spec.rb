require 'spec_helper'
require 'cluster_config'

describe security_group do
  include_context 'cluster_config'

  subject do
    Awspec::Type::SecurityGroup.new(display_name)
  end

  describe 'ecs_security_group' do
    let(:display_name) { ecs_security_group }
    it { should exist }
  end
end
