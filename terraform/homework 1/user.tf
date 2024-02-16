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
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = "terraform-bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject"
          ,"S3:PutObject"
          ,"S3:ListObject"
        ],
        Resource = "arn:aws:s3:::new-bucket/*"
      }
    ]
  })
}

#policy attach to user
resource "aws_iam_user_policy_attachment" "attachment-policy" {
  user       = aws_iam_user.my_user.name
  policy_arn = aws_iam_policy.new-bucket.arn
}
