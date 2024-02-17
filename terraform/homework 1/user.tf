provider "aws" {
    region = "ap-south-1"
}

# Craete User
resource "aws_iam_user" "my_user" {
    name = "my-user"
    path = "/system/"
}

#Create S3 Bucket 
resource "aws_s3_bucket" "  pavan_bucket" {
  bucket = "pavan_bucket"
}

resource "aws_s3_bucket_ownership_controls" "pavan_bucket" {
  bucket = aws_s3_bucket.pavan_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "pavan" {
  depends_on = [aws_s3_bucket_ownership_controls.pavan_bucket]

  bucket = aws_s3_bucket.pavan_bucket.id
  acl    = "private"
}