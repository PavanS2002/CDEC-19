provider "aws" {
    region = "ap-south-1"
}

#Create Security Group
resource "aws_security_group" "my_sg_2" {
    name = "my-sec-group"
    description = "allow ssh and http"
    vpc_id  = var.vpc_id
    ingress {
        protocol = "TCP"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]    
    }
    ingress {
        protocol = "TCP"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Launch AWS instance
resource "aws_instance" "my_first_instance" {
    ami = var.image_id
    instance_type = var.machine_type
    key_name = var.key_pair
    vpc_security_grooup_ids = var.vpc_id
    tags = {
        Name = "my-first-instnace"
        env = "dev"
    }
}

# Variables

variable "image_id" {
    default = "ami-03f4878755434977f"
}

variable "machine_type" {
    default = "t2.micro"
}

variable "key_pair" {
    default = "1.mum"
}

variable "vpc_id" {
    default = "sg-0963907b7bbf42272"
}