require 'spec_helper'

describe security_group('ecs-sg') do
  it { should exist }
end
