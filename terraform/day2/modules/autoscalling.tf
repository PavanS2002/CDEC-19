resource "aws_launch_configuration" "lc_home" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = "1.mum"
    name = "${var.project}-lc-home"
    security_groups = [var.security_group_id]
    user_data = <<-EOF 
            #!/bin/bash
            yum install httpd -y 
            echo"<h1> Hello World, Welcome to Pavan website" > /var/www/html/index.html
            systemctl start httpd
            systemctl enable httpd
            EOF
}

resorce "aws_launch_configuration" "lc_laptop" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = "1.mum"
    name = "${var.project}-lc-laptop"
    security_groups = [var.security_group_id]
    user_data = <<- EOF
            #!/bin/bash
            yum install httpd -y 
            mkdir /var/www/html/laptop
            echo "<h1> This is laptop Page" > /var/www/html/laptop/index.html
            systemctl httpd start
            systemctl https enable
            EOF 
} 

resourec "aws_launch_configuration" "lc_mobile" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = "1.mum"
    name = "${var.project}-lc-mobile"
    security_groups = [var.security_group_id]
    user_data = <<- EOF
            #!/bin/bash
            yum install httpd -y 
            mkdir /var/www/html/mobile
            echo "<h1> This is mobile Page" > /var/www/html/mobile/index.html
            systemctl httpd start
            systemctl https enable
            EOF 
} 

resource "aws_autoscalling_policy" "as_policy_home" {
    
}