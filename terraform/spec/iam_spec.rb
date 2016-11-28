require 'spec_helper'

describe iam_role('ecs_role') do
  it { should exist }
end
