provider "aws" {
    region = "ap-south-1"
    access_key = "AKIA2UC27APNWLF2YK3F"
    secret_key = "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"
}

resource "aws_iam_user" "my_user" {
    name = "my-user"
    path = "/system/"
}