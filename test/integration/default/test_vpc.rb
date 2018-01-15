require 'awspec'
require 'parseconfig'

fixtures_file = 'test/fixtures/tf_module/testing.tfvars'
tf_state_file = 'terraform.tfstate.d/kitchen-terraform-default-aws/terraform.tfstate'

terraform_tfvars_config = ParseConfig.new(fixtures_file)
tf_state = JSON.parse(File.open(tf_state_file).read)

# testing vars from .tfvars file
target_vpc_name = terraform_tfvars_config['name']
target_vpc_env = terraform_tfvars_config['environment']
target_cidr_block = terraform_tfvars_config['vpc_cidr']
target_vpc_region = terraform_tfvars_config['region']

vpc_id = tf_state['modules'][1]['outputs']['vpc_id']['value']

# testing VPC
describe vpc(vpc_id) do
  it { should exist }
  it { should be_available }

	it { should have_tag('Name').value(target_vpc_name) }
	it { should have_tag('environment').value(target_vpc_env) }
	it { should have_tag('builtWith').value('terraform') }
	its(:cidr_block) { should eq target_cidr_block }	
end
