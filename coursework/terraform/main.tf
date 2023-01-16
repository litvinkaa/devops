terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg" {
  name = "allow-all-sg-2"
  ingress {
    cidr_blocks = [
      "176.36.207.101/32"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }// Terraform removes the default rule
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
    ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
  }// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}


resource "aws_key_pair" "deployer" {
  key_name   = "terraform"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDX08+GswIPtGKIpxRaJfEBBva5guYVq0Um9WU+iuDqsKxsdN8L2UZ4kE3iGFFM9alKTG0uRMCh99/EB6xjmzRdeudoWzN3FnYHil8mV+4H2cOWw+JGwGr7hS32/a+gHUcjpy7LiR6gCOVZN17KpE/sd+y62dgkNlYwu7PLjzDbmuN3P7Po+K14QP/7fAeHmdhF+qebn5a6CAd7QTQeeeuMGwPEYC4IkXuPOj+ZPihu/4tUSElNtOKa4qXTmDnmfGqQzaY2/dC/es2qrzSbu/xHd1P0nBxDQLPD0XZUJReR0H8mFwcM0n2JqUzp4Yff5I9BHdsKOow24Q6lFzUY/XiGO9tXuu7npWidTc/SoBXiOs/BicaZ+2lHHyhMoRg+1q7icMmoXMm17nHm8Mzb4r7HGBc9BbnWjOHC0kL8Ks9b8XaWykCzAGBW/WpnBFFsntdutYE6nRbzR1Cs8j5DL1qXLjuzcxnDeT4Ycs7bnm1wMqbbSrOLy9TqpAKGAJCkAeE= misha@DESKTOP-F4GIVBJ"
}

resource "aws_instance" "app_server" {
  ami             = "ami-06878d265978313ca"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "DevOpsCourseWorkServerInstance"
  }
  user_data = file("run.sh")
}
