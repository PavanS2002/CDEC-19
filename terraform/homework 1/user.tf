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
    acl = "private"
    tags = {
        Name = "new-bucket"
        env = "dev"
    }
} 

#Create Policy For Bucket
resource "aws_s3_bucket_policy" "amazon" {
    bucket = aws_s3_bucket.amazon
    policy = jsonencode {
        version = "2012-10-17"
        statement = [{
            Effect = "Allow"
            Principal = "*"
            Action = [
                "s3:GetObject" , "s3:ListBucket" , "s3:PutObject"
            ]
            Resource = "arn:aws:s3::new-bucket"
        }
        ]
    }
}