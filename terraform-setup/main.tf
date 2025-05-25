provider "aws" {
  region = "us-east-1"  # Change this to your preferred region
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0e35ddab05955cf57" # Replace with the latest Ubuntu AMI
  instance_type = "t2.small"
  vpc_security_group_ids = ["sg-02da199474aa3214b"] # Replace it with the security group of 2048-Jenkins-Terraform-Automation
  key_name      = "default-ec2"  # Replace with your Key-name
  tags = {
    Name = "Terraform-Jenkins-Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
