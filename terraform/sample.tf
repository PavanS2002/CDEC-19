provider "aws" {
    region = "ap-south-1"
}

#Create Security Group

resource "aws_security_group" "my_sg" {
    name = "Terraform"
    description = "allow-ssh adn http"
    vpc_id = var.vpc_id
    ingress {
        protocol = "TCP"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "TCP"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#Launch AWS instance

resource "aws_instance" "my_instance" {
     ami = var.image_id
     instance_type = var.instance_type
     key_name = "1.mum"
     vpc_security_group_ids = ["sg-028e2dc3ff1d822ed"]
}

resource "aws_instance" "new_instance" {
     ami = var.image_id
     instance_type = var.instance_type
     key_name = "1.mum"
     vpc_security_group_ids = ["sg-028e2dc3ff1d822ed", "Terraform" ]
}


# Variables

Variables "image_id" {
    default = "03f4878755434977f"
}

Variables "instance_type" {
    default = "t2.micro"
}

Variables "vpc_id" {
    default = "sg-028e2dc3ff1d822ed"
}
