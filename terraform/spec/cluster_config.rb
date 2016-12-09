RSpec.shared_context 'aws_config', a: :b do
  let(:aws_region) { 'ap-southeast-2' }
  let(:aws_account) { '428447784580' }
  let(:image_id) { 'ami-5781be34' }
  let(:instance_type) { 't2.medium' }
end

RSpec.shared_context 'cluster_config', a: :b do
  let(:key_name) { 'devops_ecs' }
  let(:ecs_security_group) { 'sg-bc8a65db' }
  let(:ecs_availability_zones) { 'ap-southeast-2a,ap-southeast-2b,ap-southeast-2c' }
  let(:ecs_subnet_ids) { 'subnet-a479bed3,subnet-45e43d20,subnet-dbf5a49d' }
  let(:cluster_name) { 'test-ecs-cluster' }
  let(:launch_configuration) { "ECS-#{cluster_name}-20161209005536667650985gvx" }
end
