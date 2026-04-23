terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

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

resource "aws_subnet" "public_subnet" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.1.0/24"
}

resource "aws_instance" "ec2" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
}
