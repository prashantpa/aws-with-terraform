provider "aws" {
    region = "us-west-2"
}

resource "aws_security_group" "allowssh" {
  name        = "allowssh"
  description = "Allow ssh inbound traffic"

  ingress {
    description      = "for ssh server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myinstance" {
  ami           = "ami-0cf6f5c8a62fa5da6"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allowssh.id}"]
}




