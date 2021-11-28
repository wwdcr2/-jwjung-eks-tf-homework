locals {
  cluster_name = "${var.project}-cluster"
}

# EKS Cluster SG
resource "aws_security_group" "cluster_sg" {
  name        = "${var.project}-sg-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.cluster_name
  }
}

# EKS Cluster
resource "aws_eks_cluster" "demo" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster_sg.id]
    subnet_ids         = module.subnets["pri"].subnet_ids
  }
  enabled_cluster_log_types = ["api", "audit","authenticator","controllerManager","scheduler"] #logging /aws/eks/eks-tf-demo-cluster/cluster

  
  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]
}