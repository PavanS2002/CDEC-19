provider "aws" {
    region = "ap-south-1"
}

# Craete User
resource "aws_iam_user" "my_user" {
    name = "my-user"
    path = "/system/"
}

#Create S3 Bucket 
resource "aws_s3_bucket" "  Pavan_bucket" {
  bucket = "Pavan_bucket"
}

resource "aws_s3_bucket_ownership_controls" "Pavan_bucket" {
  bucket = aws_s3_bucket.Pavan_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "Pavan" {
  depends_on = [aws_s3_bucket_ownership_controls.Pavan_bucket]

  bucket = aws_s3_bucket.Pavan_bucket.id
  acl    = "private"
}