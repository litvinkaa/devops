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
    from_port = 3000
    to_port = 3000
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0QLNwo7+pqg2qVL9bFgGsTKnVnN1hdmkPGJMJdFJj2O0cVZTebYwjdBW4o0DZjBsWFjyDwZIZZMRiAmbfbxO/fcRlKJ6A3MScS+BTVyFEsCOLSyvCvmv/OAGIaKTi0zUnUQwjgoOLObycgvazV98IN74qW5b5kVAVnukyjOjTSakXr3+wcQfxTZhm9jJ0+r1/1U2DdVvjjPIEQ4peEHWeOg0Ggw3jnjhecSmKy6kOUweOeuBOo2GKn6X52se8ngZ7VvyGQQNSAeuwS0aMvL3XG+cOEEn6xyW2fVAE+vN2b3gx2DuKRimALdXomGryZBNfWFPS7xSh1CXwEwMTGHyaaAcUG1ryEbyRZ5PQ5LWCmF1pa72uRZuVE+/6dIzETC3dyXn7eRWQFRfr3q00+2KNi06DiGEpGfq6pq4Ppl3c7qGDwKqicGavjdRTzgWiuDIEOIHU2T2kusFV7F/Zxa8B3TFQvUNG0xA7welm8hOmmxiXUZjzfpVQpyD85LAhR0s= misha@DESKTOP-F4GIVBJ"
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
