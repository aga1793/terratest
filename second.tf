
terraform {
 backend "s3"{
 bucket = "table1-terraform-user11"
 key = "terra/state"
 region = "ap-southeast-1"
 }
}

provider "aws" {
 region = "ap-southeast-1"
}

provider "aws" {
 alias = "eu-west-2"
 region = "eu-west-2"
}

resource "aws_instance" "frontend" {
 depends_on = ["aws_instance.backend"]
 ami = "ami-070bdb8798e3aeba7"
 instance_type = "t2.medium"
 key_name = "user11-rsa"
  tags = {
   Name = "user11.frontend"
  }
  lifecycle {
   create_before_destroy = true
  }
}

resource "aws_instance" "backend" {
 count = 2
 provider = "aws.eu-west-2"
 ami = "ami-0f49c6ee8f381746f"
 instance_type = "t2.medium"
 key_name = "user11-rsa"
  tags = {
   Name = "user11.backend" 
 }
 timeouts {
  create = "60m"
  delete = "2h"
 }
}

