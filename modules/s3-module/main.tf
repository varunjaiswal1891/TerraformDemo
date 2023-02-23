resource "aws_s3_bucket" "app_image_buckets" {
bucket = var.bucket_name
}

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

#these names b_varun_bucket are terraform objects - not AWS bucket names - 
/*
resource "aws_s3_bucket" "b" {
  tags = {
    Name = "My bucket varun"
  }
  count = 4
  bucket = "2023-02-20-varunApp-bucket-${count.index}"
  //Setup S3 bucket to hold state 
  lifecycle {
    prevent_destroy = true
  }
}
*/
