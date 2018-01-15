require 'awspec'
require 'parseconfig'

fixtures_file = 'test/fixtures/tf_module/testing.tfvars'
tf_state_file = 'terraform.tfstate.d/kitchen-terraform-default-aws/terraform.tfstate'

terraform_tfvars_config = ParseConfig.new(fixtures_file)
tf_state = JSON.parse(File.open(tf_state_file).read)

# testing vars
target_vpc_name = terraform_tfvars_config['name']
target_cidr_block = terraform_tfvars_config['vpc_cidr']

vpc_id = tf_state['modules'][1]['outputs']['vpc_id']['value']

describe vpc(vpc_id) do
  it { should exist }
  it { should be_available }

  it { should have_tag('Name').value(target_vpc_name) }
  its(:cidr_block) { should eq target_cidr_block }
end
