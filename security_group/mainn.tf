provider "aws" {
  region = "us-east-1"
}
resource "aws_security_group" "my_sg" {
   description = "for-practice"
   name = "security"

ingress {
  from_port = 0
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "ec2block" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    Name = "my-server"
}
}
