provider "aws" {
    region = "ap-south-1"
}

terraform {
    backend "s3"{
        region = "ap-south-1"
        bucket = "cdec-19"
        key = "./terraform.tfstate"
    }
}

data "aws_security_group" "existing_sg" {
    name = "default"
    vpc_id = "vpc-0ef23f9098eb8a754"
}

resource "aws_security_group_rule" "allow_ssh" {
    type = "ingress"
    to_port = 22
    from_port = 22
    protocol  = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = data.aws_security_group.existing_sg.id
}

resource "aws_security_group_rule" "http" {
    type = "ingress"
    to_port = 80
    from_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = data.aws_security_group.existing_sg.id
}

resource "aws_instance" "my_instnace" {
    ami = "ami-03f4878755434977f"
    instance_type = "t2.micro"
    key_name = "1.mum"
    vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("./private.key")
        host = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get install httpd -y"
            "sudo systemctl start httpd"
            "sudo systemctl enable httpd"
        ]
    }

    provisioner "local_exec" {
        command = "echo '<h1> Hello World' > index.html"
    }

    provisioner "file" {
        source = "index.html"    
        destination = "/var/www/html/index.html"
    }
} 
