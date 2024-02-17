provider "aws" {
    region = "ap-south-1"
}

# Craete User
resource "aws_iam_user" "my_user" {
    name = "my-user"
    path = "/system/"
}

#Create S3 Bucket 
resource "aws_s3_bucket" "new_bucket" {
    bucket = "new-bucket"
    aws_s3_bucket_acl = "private"
    tags = {
        Name = "new-bucket"
        env = "dev"
    }
} 