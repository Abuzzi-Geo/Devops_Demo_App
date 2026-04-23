provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "abraham-terraform-demo-${random_id.bucket_id.hex}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Jenkins-Demo"
  }
}
