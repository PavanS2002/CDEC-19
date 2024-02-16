provider "aws" {
    region = "ap-south-1"
    access_key_id = "AKIA2UC27APNWLF2YK3F"
    secret_acces_key_id = "ew9ZaObhFxa+/+BawjM24PErErWtaOI62uiQLgBM"
}

resource "aws_iam_user" "my_user" {
    name = "my-user"
    path = "/system/"
}