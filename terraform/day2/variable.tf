variable "ami" {
    default = "ami-0e670eb768a5fc3d4"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ssh_key" {
    default = "1.mum"
}

variable "project" {
    default = "cloudblitz"
}

variable "sg_id" {
    default = "sg-028e2dc3ff1d822ed"
}

variable "min_size" {
    default = 2
} 

variable "max_size" {
    default = 4
}

variable "desired_capacity" {
    default = 2
}
 
variable "subnets" {
    default = ["subnet-0a38085c5ef70876b" , "subnet-00be2a8a594c41642"]
}
 
variable "env" {
    default = "dev"
}

variable "vpc_id" {
    default = "vpc-0ef23f9098eb8a754"
}

variable "azs" {
    default = ["ap-south-1c" , "ap-south-1b"]
}