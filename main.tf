terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.45.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
  shared_config_files = ["/Users/Jaskaran.Singh/.aws/credentials"]
  profile = "hello-world"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh traffic"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
  count = 1

  user_data = "${file("script.sh")}"
  user_data_replace_on_change = true

  key_name = "helloworld"

  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "HelloWorld"
  }
}


output "instances" {
  value       = "${aws_instance.web.*.private_ip}"
  description = "PrivateIP address details"
}

