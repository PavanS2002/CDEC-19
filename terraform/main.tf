provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "${var.project}-vpc"
        env = var.env
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet_cidr
    tags = {
        Name = var.env
        env = "${var.project}-private-subnet"
    } 
}

resource "aws-subnet" "public_subnet" {
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true
    tags = {
        Nmae = "${var.project}-public-subnet"
        env  = var.env
    }
}

resource = "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.project}-igw"
        env = var.env
    }
}

resource "aws_route" "igw_route" {
    route_table_id         = aws_vpc.my_vpc.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id 
}

resource "aws_security_group" "my_sg" {
    name = "${var.project}-sg"
    description = "allow http and ssh"
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "TCP"
        from_port = 80
        to_port = 80
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        protcol = "TCP"
        from_port = 22
        to_port = 22
    }
    egress {
        cidr_blocks =["0.0.0.0/0"]
        protocol = "-1"
        from_port = 0
        to_port = 0   
    }
    depends_on = [aws_internet_gateway.my_igw]     
}

resource "aws_instance" "instance_1" {
    ami = var.image_id
    instance_type = var.instance_tyoe
    key_name = var.key_pair
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    tags = {
        Name = "${var.project}-private_subnet.id"
        env = var.env
    }
    subnet_id = aws_subnet.private_subnet.id
}

resource "aws_instance" "instance_2" {
    ami = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    tags = {
        Name = "${var.project}-public-instace"
        env = var.env
    }
    subnet_id = aws_subnet.public_subnet.id
}