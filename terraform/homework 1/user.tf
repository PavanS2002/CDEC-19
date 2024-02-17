provider "aws" {
    region = "ap-south-1"
}

# Craete User
resource "aws_iam_user" "new_user" {
    name = "new-user"
    path = "/"
}

#Create S3 Bucket 
resource "aws_s3_bucket" "my_bucket" {
  bucket = "new-bucket"
}

resource "aws_s3_bucket_ownership_controls" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.my_bucket]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}