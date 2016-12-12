require 'spec_helper'

describe vpc do
  include_context 'cluster_config'

  subject do
    Awspec::Type::Vpc.new(display_name)
  end

  describe 'vpc' do
    let(:display_name) { vpc_id }

    it { should exist }
    it { should be_available }
    it { should have_route_table("#{vpc_name}-rt-public") }

    its(:vpc_id) { should eq vpc_id }
  end
end

describe route_table do
  include_context 'cluster_config'

  subject do
    Awspec::Type::RouteTable.new(display_name)
  end

  describe 'public_route_table' do
    let(:display_name) { "#{vpc_name}-rt-public" }

    it { should exist }
    it { should have_route('10.10.0.0/16').target(gateway: 'local') }
    it { should have_route('0.0.0.0/0').target(gateway: vpc_igw) }
    it { should have_subnet("#{vpc_name}-subnet-public-ap-southeast-2a") }
    it { should have_subnet("#{vpc_name}-subnet-public-ap-southeast-2b") }

    its(:vpc_id) { should eq vpc_id }
  end

# TODO: Add the NAT Gateway route tests

  describe 'private_route_table-ap-southeast-2a' do
    let(:display_name) { "#{vpc_name}-rt-private-ap-southeast-2a" }

    it { should exist }
    it { should have_route('10.10.0.0/16').target(gateway: 'local') }
    it { should have_subnet("#{vpc_name}-subnet-private-ap-southeast-2a") }

    its(:vpc_id) { should eq vpc_id }
  end

  describe 'private_route_table-ap-southeast-2b' do
    let(:display_name) { "#{vpc_name}-rt-private-ap-southeast-2b" }

    it { should exist }
    it { should have_route('10.10.0.0/16').target(gateway: 'local') }
    it { should have_subnet("#{vpc_name}-subnet-private-ap-southeast-2b") }

    its(:vpc_id) { should eq vpc_id }
  end
end

describe subnet do
  include_context 'cluster_config'

  subject do
    Awspec::Type::Subnet.new(display_name)
  end

  describe 'private-subnet-ap-southeast-2a' do
    let(:display_name) { "#{vpc_name}-subnet-private-ap-southeast-2a" }

    it { should exist }
    it { should be_available }

    its(:vpc_id) { should eq vpc_id }
    its(:cidr_block) { should eq '10.10.1.0/24' }
    its(:availability_zone) { should eq 'ap-southeast-2a' }
    its(:map_public_ip_on_launch) { should eq false }
  end

  describe 'private-subnet-ap-southeast-2b' do
    let(:display_name) { "#{vpc_name}-subnet-private-ap-southeast-2b" }

    it { should exist }
    it { should be_available }

    its(:vpc_id) { should eq vpc_id }
    its(:cidr_block) { should eq '10.10.2.0/24' }
    its(:availability_zone) { should eq 'ap-southeast-2b' }
    its(:map_public_ip_on_launch) { should eq false }
  end

  describe 'public-subnet-ap-southeast-2a' do
    let(:display_name) { "#{vpc_name}-subnet-public-ap-southeast-2a" }

    it { should exist }
    it { should be_available }

    its(:vpc_id) { should eq vpc_id }
    its(:cidr_block) { should eq '10.10.101.0/24' }
    its(:availability_zone) { should eq 'ap-southeast-2a' }
    its(:map_public_ip_on_launch) { should eq true }
  end

  describe 'public-subnet-ap-southeast-2b' do
    let(:display_name) { "#{vpc_name}-subnet-public-ap-southeast-2b" }

    it { should exist }
    it { should be_available }

    its(:vpc_id) { should eq vpc_id }
    its(:cidr_block) { should eq '10.10.102.0/24' }
    its(:availability_zone) { should eq 'ap-southeast-2b' }
    its(:map_public_ip_on_launch) { should eq true }
  end
end

# TODO: NAT Gateway Tests
