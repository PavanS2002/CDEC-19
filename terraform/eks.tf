provider "aws"  {
    region = "ap-south-1"
}
#vpc
resource "aws_vpc" "eks_main" {
  cidr_block       = "10.0.0.0/18"
  instance_tenancy = "default"
  tags = {
    Name = "eks-main"
  }
}

#subnets
resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.eks_main.id
    cidr_block = "10.0.0.0/22"
    tags = {
        Name = "subnet-1"
    }
} 

resource "aws_subnet" "subnet_2" {
 vpc_id = aws_vpc.eks_main.id
 cidr_block = "10.0.1.0/22"
 tags = {
    Name = "subnet-2"
 }
}
#iam role
 resource "aws_iam_role" "eks_role" {
  name = "eks_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "for-eks-role"
  }
} 
#iam policy attachment
resource "aws_iam_role_policy_attachment" "eks_k8s" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_role.name
}
#cluster
resource "aws_eks_cluster" "first_cluster" {
    name = "new_cluster"
    role_arn = aws_iam_role.eks_role.arn

vpc_config {
    subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}
}
