resource "aws_launch_configuration" "lc_home" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    name = "${var.project}-lc-home"
    security_groups = [var.security_group_id]
    user_data = <<-EOF
            #!/bin/bash
            yum install httpd -y
            echo "<h1> Hello World, Welcome to Cloudblitz" > /var/www/html/index.html
            systemctl start httpd
            systemctl enable httpd
            EOF
}

resource "aws_launch_configuration" "lc_laptop" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    name = "${var.project}-lc-laptop"
    security_groups = [var.security_group_id]
    user_data = <<-EOF
            #!/bin/bash
            yum install httpd -y
            mkdir /var/www/html/laptop
            echo "<h1> This is Laptop Page" > /var/www/html/laptop/index.html
            systemctl start httpd
            systemctl enable httpd
            EOF
}

resource "aws_launch_configuration" "lc_mobile" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    name = "${var.project}-lc-mobile"
    security_groups = [var.security_group_id]
    user_data = <<-EOF
            #!/bin/bash
            yum install httpd -y
            mkdir /var/www/html/mobile
            echo "<h1> Mobile Page" > /var/www/html/mobile/index.html
            systemctl start httpd
            systemctl enable httpd
            EOF
}



resource "aws_autoscaling_group" "as_home" {
    name = "${var.project}-as-home"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    availability_zones = var.azs
    launch_configuration = aws_launch_configuration.lc_home.name
    tag {
        key = "Name"
        value = "home"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "as_policy_home" {
  autoscaling_group_name = aws_autoscaling_group.as_home.name
  name                   = "${var.project}-as-policy-home"
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 50
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "app/cloudblitz-lb/778d41231b141a0f/targetgroup/cloudblitz-tg-home/943f017f100becff"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = aws_autoscaling_group.as_home.name
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
}


resource "aws_autoscaling_group" "as_laptop" {
    name = "${var.project}-as-laptop"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    availability_zones = var.azs
    launch_configuration = aws_launch_configuration.lc_laptop.name
    tag {
        key = "Name"
        value = "laptop"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "as_policy_laptop" {
  autoscaling_group_name = aws_autoscaling_group.as_laptop.name
  name                   = "${var.project}-as-policy-laptop"
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 50
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "app/cloudblitz-lb/778d41231b141a0f/targetgroup/cloudblitz-tg-laptop/943f017f100becff"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = aws_autoscaling_group.as_laptop.name
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
}


resource "aws_autoscaling_group" "as_mobile" {
    name = "${var.project}-as-mobile"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    availability_zones = var.azs
    launch_configuration = aws_launch_configuration.lc_mobile.name
    tag {
        key = "Name"
        value = "mobile"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "as_policy_mobile" {
  autoscaling_group_name = aws_autoscaling_group.as_mobile.name
  name                   = "${var.project}-as-policy-mobile"
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 50
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "app/cloudblitz-lb/778d41231b141a0f/targetgroup/cloudblitz-tg-mobile/943f017f100becff"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = aws_autoscaling_group.as_mobile.name
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
}

