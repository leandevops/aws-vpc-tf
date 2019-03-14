require 'awspec'
require 'parseconfig'

fixtures_file = 'tests/fixtures/tf_module/testing.tfvars'
tf_state_file = 'terraform.tfstate'

terraform_tfvars_config = ParseConfig.new(fixtures_file)
tf_state = JSON.parse(File.open(tf_state_file).read)

# testing vars from .tfvars file
# VPC
target_vpc_id = tf_state['modules'][1]['outputs']['vpc_id']['value']
target_vpc_name = terraform_tfvars_config['name']
target_vpc_env = terraform_tfvars_config['environment']
target_cidr_block = terraform_tfvars_config['vpc_cidr']

# Internet gateway
target_internet_gateway = tf_state['modules'][1]['resources']['aws_internet_gateway.self']['primary']['id']

# NAT gateway
target_nat_gateway = tf_state['modules'][1]['resources']['aws_nat_gateway.self']['primary']['id']
target_eip = tf_state['modules'][1]['resources']['aws_eip.self']['primary']['attributes']['public_ip']

# Route table
target_route_table = tf_state['modules'][1]['resources']['aws_route_table.public']['primary']['id']

# Subnets
target_public_subnets = tf_state['modules'][1]['outputs']['public_subnets']['value']
target_private_subnets = tf_state['modules'][1]['outputs']['private_subnets']['value']
all_subnets = target_public_subnets + target_private_subnets

# Testing VPC
describe vpc(target_vpc_id) do
  it { should exist }
  it { should be_available }
  it { should have_tag('Name').value(target_vpc_name) }
  it { should have_tag('environment').value(target_vpc_env) }
  it { should have_tag('builtWith').value('terraform') }
  its(:cidr_block) { should eq target_cidr_block }
end

# Testing internet gateway
describe internet_gateway(target_internet_gateway) do
  it { should exist }
  it { should be_attached_to(target_vpc_id) }  
  it { should have_tag('environment').value(target_vpc_env) }
  it { should have_tag('builtWith').value('terraform') }
end

# Testing route table and routes
describe route_table(target_route_table) do
  it { should exist }
  it { should have_tag('environment').value(target_vpc_env) }
  it { should have_tag('builtWith').value('terraform') }
  it { should have_route(target_cidr_block).target(gateway: 'local') }
  it { should have_route('0.0.0.0/0').target(gateway: target_internet_gateway) }
end

describe nat_gateway(target_nat_gateway) do
  it { should exist }
  it { should be_available }
  it { should have_eip(target_eip) }
  it { should belong_to_vpc(target_vpc_id) }
end

# Testing subnets
all_subnets.each do |subnet|
  describe subnet(subnet) do
    it { should exist }
    it { should be_available }
    its('vpc.id') { should eq target_vpc_id }
    it { should have_tag('environment').value(target_vpc_env) }
    it { should have_tag('builtWith').value('terraform') }
  end
end

# Testing public subnets
target_public_subnets.each do |public_subnet|
  describe subnet(public_subnet) do
    its(:map_public_ip_on_launch) { should eq true }
  end
end

# Testing private subnets
target_private_subnets.each do |private_subnet|
  describe subnet(private_subnet) do
    its(:map_public_ip_on_launch) { should eq false }
  end
end
