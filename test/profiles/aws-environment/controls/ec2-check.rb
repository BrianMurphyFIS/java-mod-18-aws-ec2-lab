title 'EC2 Environment checks'


control 'EC2 Template Instance' do
  impact 'critical'
  title 'EC2 Template Instance'
  desc 'Check if EC2 Template Instance exists.'
  desc 'step', '1'

  describe.one do
    describe "instance" do
      # purposely failing test to work around describe.one bug
      it { should eq "running" }
    end
    aws_ec2_instances.where(name: 'template-server').instance_ids.each do |instance|
      describe aws_ec2_instance(instance_id: instance) do
        its('name') { should eq 'template-server' }
        its('instance_type') { should eq 't2.micro' }
        its('key_name') { should eq 'flatironschool-ec2-key' }
        it { should exist }
      end
    end
  end

  describe.one do
    describe "image" do
      # purposely failing test to work around describe.one bug
      it { should eq "exist" }
    end
    aws_ec2_instances.where(name: 'template-server').instance_ids.each do |instance|
      image_id = aws_ec2_instance(instance_id: instance).image_id
      describe aws_ami(image_id: image_id) do
        its('name') { should match 'ubuntu-jammy-22.04-amd64-server' }
      end
    end
  end
end


control 'EC2 AMI' do
  impact 'critical'
  title 'EC2 AMI'
  desc 'Check if Docker Ubuntu AMI has been created.'
  desc 'step', '2'

  describe.one do
    describe "image" do
      # purposely failing test to work around describe.one bug
      it { should eq "exist" }
    end
    aws_amis(name: 'docker-ami').image_ids.each do |image|
      describe aws_ami(image_id: image) do
        it { should exist }
      end
    end
  end
end


control 'EC2 Application Instance' do
  impact 'critical'
  title 'EC2 Application Instance'
  desc 'Check if EC2 Application Instance exists and is running.'
  desc 'step', '3'

  describe.one do
    describe "instance" do
      # purposely failing test to work around describe.one bug
      it { should eq "running" }
    end
    aws_ec2_instances.where(name: 'application-server-1').instance_ids.each do |instance|
      describe aws_ec2_instance(instance_id: instance) do
        its('name') { should eq 'application-server-1' }
        its('instance_type') { should eq 't2.micro' }
        its('key_name') { should eq 'flatironschool-ec2-key' }
        it { should exist }
        it { should be_running }
      end
    end
  end

  describe.one do
    describe "image" do
      # purposely failing test to work around describe.one bug
      it { should eq "exist" }
    end
    aws_ec2_instances.where(name: 'application-server-1').instance_ids.each do |instance|
      image_id = aws_ec2_instance(instance_id: instance).image_id
      describe aws_ami(image_id: image_id) do
        its('name') { should eq 'docker-ami' }
      end
    end
  end
end


control 'EC2 Application Security Groups' do
  impact 'critical'
  title 'EC2 Application Security Groups'
  desc 'Check if EC2 Application instance has the correct security rules applied.'
  desc 'step', '4'

  describe.one do
    describe "rule" do
      # purposely failing test to work around describe.one bug
      it { should eq "exists" }
    end
    aws_ec2_instances.where(name: 'application-server-1').instance_ids.each do |instance|
      security_group_id = aws_ec2_instance(instance_id: instance).security_groups[0][:id]
      describe aws_security_group(group_id: security_group_id) do
        it { should exist }
        it { should_not allow_in(ipv4_range: '0.0.0.0/0') }
        it { should allow_in(port: 22) }
        it { should allow_in(port: 80) }
        it { should allow_in(port: 443) }
      end
    end
  end
end


control 'EC2 Database Instance' do
  impact 'critical'
  title 'EC2 Database Instance'
  desc 'Check if EC2 Database instance exists and is running.'
  desc 'step', '6'

  describe.one do
    describe "instance" do
      # purposely failing test to work around describe.one bug
      it { should eq "running" }
    end
    aws_ec2_instances.where(name: 'database-server-1').instance_ids.each do |instance|
      describe aws_ec2_instance(instance_id: instance) do
        its('name') { should eq 'database-server-1' }
        its('instance_type') { should eq 't2.micro' }
        its('key_name') { should eq 'flatironschool-ec2-key' }
        it { should exist }
        it { should be_running }
      end
    end
  end

  describe.one do
    describe "image" do
      # purposely failing test to work around describe.one bug
      it { should eq "exist" }
    end
    aws_ec2_instances.where(name: 'database-server-1').instance_ids.each do |instance|
      image_id = aws_ec2_instance(instance_id: instance).image_id
      describe aws_ami(image_id: image_id) do
        its('name') { should eq 'docker-ami' }
      end
    end
  end
end


control 'EC2 Database Security Groups' do
  impact 'critical'
  title 'EC2 Database Security Groups'
  desc 'Check if EC2 Database instance has the correct security rules applied.'
  desc 'step', '7'

  describe.one do
    describe "rule" do
      # purposely failing test to work around describe.one bug
      it { should eq "exists" }
    end
    aws_ec2_instances.where(name: 'database-server-1').instance_ids.each do |instance|
      security_group_id = aws_ec2_instance(instance_id: instance).security_groups[0][:id]
      describe aws_security_group(group_id: security_group_id) do
        it { should exist }
        it { should_not allow_in(ipv4_range: '0.0.0.0/0') }
        it { should allow_in(port: 22) }
        it { should allow_in(port: 6379, ipv4_range: '172.31.0.0/16') }
      end
    end
  end
end


control 'EC2 Packer AMI' do
  impact 'critical'
  title 'EC2 Packer AMI'
  desc 'Check if Packer AMI has been created.'
  desc 'step', '9'
  desc 'optional', 'true'

  describe.one do
    describe "image" do
      # purposely failing test to work around describe.one bug
      it { should eq "exist" }
    end
    aws_amis(name: 'learn-packer-linux-aws').image_ids.each do |image|
      describe aws_ami(image_id: image) do
        it { should exist }
      end
    end
  end
end
