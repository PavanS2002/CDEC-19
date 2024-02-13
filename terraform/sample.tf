provider "aws" {
    region = "ap-south-1"
}

resource  "aws_instance" "my_instance" {
    ami = "ami-03f4878755434977f"
    instance_type = "t2.micro"
    key_name = "1.mum"
    vpc_security_group_ids = [sg-028e2dc3ff1d822ed]
    tags = {
        Nmae = "Pavan"
        env = "dev"
    }
}