RSpec.shared_context 'aws_config', a: :b do
  let(:aws_region) { 'ap-southeast-2' }
  let(:aws_account) { '428447784580' }
  let(:image_id) { 'ami-5781be34' }
  let(:instance_type) { 't2.medium' }
end

RSpec.shared_context 'cluster_config', a: :b do
  let(:key_name) { 'devops-ecs' }
  let(:ecs_security_group) { 'sg-01ab1864' }
  let(:cluster_name) { 'test-ecs-cluster' }
  let(:launch_configuration) { "ECS-#{cluster_name}20161201065111174482289ovi" }
end
