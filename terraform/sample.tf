provider "aws" {
    region = "us-east-1"
}


# Create Security Group
resource "aws_security_group" "my_sg" {
    name = "my-sec-group"
    description = "allow-ssh and http"
    vpc_id = var.vpc_id
    ingress {
        protocol = "TCP"
        from_port = 22
        to_port  = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "TCP"
        from_port = "80"
        to_port  = "80"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"  
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Launch AWS Instance
resource "aws_instance" "my_instance" {
    ami = var.image_id
    instance_type = var.machine_type
    key_name = "shubham-nv"
    vpc_security_group_ids = [ "sg-0f201ab5b246cee99", aws_security_group.my_sg.id ]
    tags = {
        Name = "my-instance"
        env = "dev"
    }
}

resource "aws_instance" "another_instance" {
    ami = var.image_id
    instance_type = var.machine_type
    key_name = "shubham-nv"
    vpc_security_group_ids = ["sg-0f201ab5b246cee99"]
    tags = {
        Name = "another-instance"
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

variable "vpc_id" {
    default = "sg-0f201ab5b246cee99"
}