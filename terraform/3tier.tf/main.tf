provider "aws" {
    region = "ap-south-1"
}

#Create VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

#Create VPC Public Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.0.0/24"
}

#Create VPC Private Subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}

#Create AWS Internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

#Create AWS Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

#Create AWS Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#Create AWS Security Group 
resource "aws_security_group" "this" {
  name_prefix = "sg"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create AWS Load Balancer
resource "aws_alb" "this" {
  name            = "alb"
  internal        = false
  security_groups = [aws_security_group.this.id]
  subnets         = [aws_subnet.public.id]

  tags = {
    Environment = "production"
  }
}

# rds_db_subnet_group.tf
resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name       = "dac_db_subnet_group"
  subnet_ids = [aws_subnet.rds_db_subnet_1.id, aws_subnet.rds_db_subnet_2.id]

  tags = {
    Name = "rds_db_subnet_group"
  }
}

# rds_db.tf
resource "aws_db_instance" "dac_db" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "mydb"
  identifier              = "dacdb"
  username                = "<db_user>"
  password                = "<db_password>"
  parameter_group_name    = "default.mysql8.0"
  db_subnet_group_name    = aws_db_subnet_group.dac_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.dac_db_sg.id]
  skip_final_snapshot     = "true"
}