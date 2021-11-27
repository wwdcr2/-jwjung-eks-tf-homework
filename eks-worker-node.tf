#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#


resource "aws_eks_node_group" "node_group" {
  cluster_name    = local.cluster_name
  node_group_name = "${var.project}-node"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.subnets["pri"].subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 3
  }

  # depends_on = [
  #   aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicyy,
  #   aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
  #   aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
  # ]
}