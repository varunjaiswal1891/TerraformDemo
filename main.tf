/*
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~>0.12.0"
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

#type and name of resoucre 
resource "aws_instance" "app_server" {
  // ami                    = var.image_id
  ami                    = "ami-0f1a5f5ada0e7da53"
  instance_type          = "t2.micro"
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

#these names b_varun_bucket are terraform objects - not AWS bucket names - 
/*
resource "aws_s3_bucket" "b" {
  tags = {
    Name = "My bucket varun"
  }
  count = 4
  bucket = "2023-02-20-varunApp-bucket-${count.index}"
}
*/

resource "aws_security_group" "allow_port_8080" {
  name        = "allow_port_8080"
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

//looping on resource to create 3 S3 buckets
/*
variable "bucket_names" {
  description = "List of bucket name"
  type = list(string)
  default = [ "main","backup","dev" ]
}
resource "aws_s3_bucket" "app_image_buckets" {
  for_each = toset(var.bucket_names)
  bucket = "app-image-bucket-${each.value}"
}
*/

//using data variables
data "aws_vpc" "default" {
  default = true
}
//output this data variable
output "aws_default_vpc_info" {
  value = data.aws_vpc.default
}