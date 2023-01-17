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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9KlzAo+MaHoWXQm2lI8ngU3jmZyiLVX5jqorlGHa5fah5AT3Td+euxFFYPeEB49rgf4FiI2OQUPLMg4lAwYrrbtaqsXzU0Rj1fco0dll14cAJqoh/Xzcob1hmdzNcfxeMgj/tZefwEWMZ5Lh+2+pS67WnrrGbydFAq/VX78LJsCzDweYmxo3JP62pKBdjopZsy3raOrLDtB0RPBxHExvRdmlig1cRBbgh5onTutqGOiHinjah7XmNZk4GztPehb6U4H/jA4Sui9f3bVGBKnrBDDWOlkPbpl1NTHCY76IO51bnlpINTrkjRvhi5TM7FzltZArfoZOWQnjJwxjwia21rTchrQr20INkTydBNPQ6ZnMnJKiGpp5pStwO+zRPBnMe4p/ByJVAnrDgMs1pnxJ0vAYIeaNUVhMhcaHOOJf6Zk0FfHiDRP6eNH6izGir7YM/nSRqjSu/KSYGvnCJp7YBPJ54F2EA9RVWN9BBny49hocqTBFmzWC9HZHxn2iRWvU= misha@DESKTOP-F4GIVBJ"
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
