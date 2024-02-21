resource "aws_lb_target_group" "tg_home" {
  name     = "${var.project}-tg-home"
  port     = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = {
    Env = var.env
  }
  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "tg_mobile" {
  name     = "${var.project}-tg-mobile"
  port     = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = {
    Env = var.env
  }
  health_check {
    path = "/mobile/"
  }
}

resource "aws_lb_target_group" "tg_laptop" {
  name     = "${var.project}-tg-laptop"
  port     = 80
  protocol = "HTTP"  
  vpc_id = var.vpc_id
  tags = {
    Env = var.env
  }
  health_check {
    path = "/laptop/"
  }
}

resource "aws_lb" "lb" {
  name               = "${var.project}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids
  tags = {
    Env = var.env
  }
}

resource "aws_lb_listener" "home" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_home.arn
  }
}

resource  "aws_lb_listener_rule" "laptop_rule" {
  listener_arn = aws_lb_listener.home.arn
  priority     = 101

  condition {
    path_pattern {
      values = ["/laptop*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_laptop.arn
  }
}

resource  "aws_lb_listener_rule" "mobile_rule" {
  listener_arn = aws_lb_listener.home.arn
  priority     = 102

  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_mobile.arn
  }
}

resource "aws_autoscaling_attachment" "asg-tg-home" {
  autoscaling_group_name = var.autoscaling_group_name_home
  lb_target_group_arn    = aws_lb_target_group.tg_home.arn
}

resource "aws_autoscaling_attachment" "asg-tg-laptop" {
  autoscaling_group_name = var.autoscaling_group_name_laptop
  lb_target_group_arn    = aws_lb_target_group.tg_laptop.arn
}

resource "aws_autoscaling_attachment" "asg-tg-mobile" {
  autoscaling_group_name = var.autoscaling_group_name_mobile
  lb_target_group_arn    = aws_lb_target_group.tg_mobile.arn
}