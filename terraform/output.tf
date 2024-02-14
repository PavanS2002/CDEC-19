output "hello_world" {
    value = "Hello World. Welcome to Terraform"
}

output "public-instance-public-ip" {
    value = aws_instance.instance_2.public_ip
}

output "public-instance-state" {
    value = aws_instance.instance_2.instance_state
}

output "private-instance-state" {
    value = aws_instance.instance_1.instance_state
}