require 'spec_helper'
require 'cluster_config'

describe vpc do
  include_context 'cluster_config'

  subject do
    Awspec::Type::Vpc.new(display_name)
  end

  describe 'vpc' do
    let(:display_name) { vpc_id }

    it { should exist }
    it { should be_available }
  end
end
