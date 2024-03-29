provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "192.168.0.0/16"
    tags = {
        Name = "my_vpc"
        env = "dev"
    }
}

resource "aws_instance" "home_instance" {
    ami  = "ami-03f4878755434977f"
    key_name = "1.mum"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.home_sg.id]
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_security_group" "home_sg" {
    name = "home"
    description = "allow http and ssh"
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        protocol = "TCP"
        to_port  = 22
        from_port = 22
        cidr_blocks = ["0.0.0.0/16"]
    }
    ingress {
        protocol = "TCP"
        to_port = 80
        from_port = 80
        cidr_blocks = ["0.0.0.0/16"]
    }
    egress {
        protocol = "-1"
        to_port = 0
        from_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_eip" "home-eip" {
  instance = aws_instance.home_instance.id
  vpc      = "true"
  tags = {
    name = "home-eip"
    env = "dev"
  }
}

# Associate the Elastic IP to the instance
resource "aws_eip_association" "VPC_A_EIP-Association" {
  instance_id   = aws_instance.home_instance.id
  allocation_id = aws_eip.home-eip.id
}