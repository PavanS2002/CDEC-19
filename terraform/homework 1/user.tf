provider "aws" {
    region = "ap-south-1"
}

# Craete User
resource "aws_iam_user" "my_user" {
    name = "my-user"
    path = "/"
}

#Create S3 Bucket 
resource "aws_s3_bucket" "pavan_bucket" {
<<<<<<< HEAD
  bucket = "new_bucket"
=======
  bucket = "new-bucket"
>>>>>>> 92393c7de945d50f3ae2f9a3ac296f978417d9d1
}

resource "aws_s3_bucket_ownership_controls" "pavan_bucket" {
  bucket = aws_s3_bucket.pavan_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "pavan_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.pavan_bucket]

  bucket = aws_s3_bucket.pavan_bucket.id
  acl    = "private"
}