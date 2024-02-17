provider "aws" {
    region = "ap-south-1"
    profile = var.aws_profile
}

#Create vpc
resource "aws_vpc" "my_vpc" {

  name = "main"
  vpc_cidr = var.vpc_cidr

  azs              = ["ap-south-1a", "ap-south-1b"]
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway = true

  public_subnet_names   = ["web-subnet-1", "web-subnet-2"]
  private_subnet_names  = ["app-subnet-1", "app-subnet-2"]
  database_subnet_names = ["db-subnet-1", "db-subnet-2"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#Create AWS Security Group
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow inbound traffic for web tier"
  vpc_id      = aws_vpc.my_vpc.id
} 


resource "aws_security_group_rule" "web" {
  security_group_id = aws_security_group.web.id

ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "web_ssh" {
  security_group_id = aws_security_group.web.id

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"] # Replace with your desired CIDR blocks for SSH access
  }
}


#Create AWS Launch Template
resource "aws_launch_template" "my_web" {
  name_prefix   = "web-lt-"
  image_id      = "ami-0449c34f967dbf18a"
  instance_type = var.my_web

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(templatefile("${path.module}/userdata_web.tpl", {}))

  lifecycle {
    create_before_destroy = true
  }
}

#Create AWS AutoScaling Group
resource "aws_autoscaling_group" "web" {
  name_prefix          = "web-asg-"
  launch_configuration = aws_launch_template.my_web.id
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2
  vpc_zone_identifier  = aws_vpc.public_subnets
  target_group_arns    = [aws_lb_target_group.web.arn]

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#Create Load Balancer
resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = aws_vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_id
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb" "app" {
  name               = "app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app.id]
  subnets            = aws_vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_id
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

#Database Subnet Group
resource "aws_db_subnet_group" "db" {
  name       = "db"
  subnet_ids = aws_vpc.database_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#Security Group For RDS
resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow inbound traffic for db tier"
  vpc_id      = aws_vpc.vpc_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "rds" {
  security_group_id = aws_security_group.rds.id

  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
}

#RDS Instance
resource "aws_security_group_rule" "rds_123" {
  security_group_id = aws_security_group.rds.id

  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  db_name                = "mysql_db"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az = var.multi_az

  availability_zone = "us-west-1"

  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}