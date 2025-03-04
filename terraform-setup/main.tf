provider "aws" {
  region = "eu-central-1"  # Change this to your preferred region
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-07eef52105e8a2059" # Replace with the latest Ubuntu AMI
  instance_type = "t2.small"
  vpc_security_group_ids = ["sg-0acdfbd8a974c1058"] # Replace it with the security group of 2048-Jenkins-Terraform-Automation
  key_name      = "master_jenkins"  # Replace with your Key-name
  tags = {
    Name = "Terraform-Jenkins-Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
