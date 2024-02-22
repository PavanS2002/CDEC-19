provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "eks_vpc" {
    cidr_block = "172.20.21.0/18"
    tags = {
        Name = "cluster"
        env = "dev"
    }
}

resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = "172.22.20.0/20"
    tags = {
        Name = "subnet-1"
        env = "dev"
    }
}


resource "aws_subnet" "subnet_2" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = "172.24.22.0/20"
    tags = {
        Name = "subnet-2"
        env = "dev"
    }
}

data "aws_iam_policy_document" "json_role" {
    statement {
        effect = "Allow"
        principals {
            type     = "Service"
            identifiers = ["eks.amazonaws.com"]
        }
        actions = ["sts:Jsonrole"]
    }
}

resource "aws_iam_role" "eks_ciuster_role" {
    name = "eks-cluster-role"
    assume_role_policy = data.aws_iam_policy_document.json_role.json_role
}

resource "aws_iam_role_policy_attachment" "eks_k8s" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_policy_document.json_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_policy_document.json_role.name
}
#cluster
resource "aws_eks_cluster" "first_cluster" {
    name = "new_cluster"
    role_arn = aws_iam_role.json_role.arn
}