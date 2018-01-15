require 'awspec'
require 'parseconfig'

fixtures_file = 'test/fixtures/tf_module/testing.tfvars'
tf_state_file = 'terraform.tfstate.d/kitchen-terraform-default-aws/terraform.tfstate'

terraform_tfvars_config = ParseConfig.new(fixtures_file)
tf_state = JSON.parse(File.open(tf_state_file).read)

instance_id = tf_state['modules'][1]['resources']['aws_instance.example']['primary']['id']
# instance_ami = tf_state['modules'][1]['resources']['aws_instance.example']['primary']['attributes']['ami']
# subnet_id = tf_state['modules'][1]['resources']['aws_instance.example']['primary']['attributes']['subnet_id']
# type = tf_state['modules'][1]['resources']['aws_instance.example']['primary']['attributes']['instance_type']

describe ec2(instance_id) do    
    # it { should exist }
    # it { should be_running }
    
    # its(:image_id) { should eq instance_ami }
    # its(:instance_type) { should eq type }

    # it { should have_security_group('default') }
    # it { should belong_to_subnet subnet_id }
    # it { should_not be_disabled_api_termination }
end
