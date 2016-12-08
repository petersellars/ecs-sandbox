require 'spec_helper'

describe s3_bucket('lic-ecs') do
  it { should exist }
  it { should have_versioning_enabled }
  it { should have_object('ecs.config') }

  its(:name) { should eq 'lic-ecs' }
end
