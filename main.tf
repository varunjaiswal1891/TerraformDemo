/*
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~>0.12.0"
  //configure remote backend for terraform to lock and hold state file for multiple developers to work by acquiring lock 
  backend "s3" {
    bucket = "terraform-app-state"
    key = "global/s3/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform_state_lock"
    encrypt = true
  }
}
*/


provider "aws" {
  profile = "default"
  //region  = "ap-south-1"
  region = "us-west-2"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}



//this is output variable
output "public_ip" {
  #value = aws_instance.app_server
  value = aws_instance.app_server.public_ip
}

module "my-s3-module" {
  source = "./modules/s3-module"
  bucket_name = "varun-test-bucket"
}

#type and name of resoucre 
resource "aws_instance" "app_server" {
  // ami                    = var.image_id
  ami                    = "ami-0f1a5f5ada0e7da53"
  instance_type          = "t2.micro"
  //instance_type        = terraform.workspace == "dev" ? "t2.micro":"t2.medium"
  vpc_security_group_ids = [aws_security_group.allow_port_8080.id]
  user_data              = <<-EOF
    #!/bin/bash
    echo "<h1>my serve is up varun</h1>" > index.html
    nohup busybox httpd -f -p ${var.port_number}
  EOF
  tags = {
    Name = "ec2-${var.tag_name}"
  }
}

/*
resource "aws_vpc" "varun_app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.tag_name
  }
}
*/



resource "aws_security_group" "allow_port_8080" {
  name        = "${terraform.workspace}-allow_port_8080"
  description = "Allow 8080 inbound traffic"
 // vpc_value_temp = data.aws_vpc.default
  ingress {
    from_port   = var.port_number
    to_port     = var.port_number
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //it means allow all IPs to incoming port 8080 on EC2 instance
  }
  tags = {
    Name = "sg-${var.tag_name}"
  }

}

//local variable use
locals {
  temp_port = 9000
}
//to use this variable write as - local.temp_port



//using data variables
data "aws_vpc" "default" {
  default = true
}
//output this data variable
output "aws_default_vpc_info" {
  value = data.aws_vpc.default
}
data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.default.id 
}

//setup DynamoDB to support locking
/*
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "lock_id"
  attribute {
    name = "lock_id"
    type = "S"
  }
}
*/


//Copy and paste into your Terraform configuration below lines, insert the variables, and run terraform init:
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
}