# #self managed node group
# module "eks_sm_node_group" {
#   source = "github.com/aws-samples/amazon-eks-self-managed-node-group"

#   eks_cluster_name = "eks-cluster"
#   instance_type    = "t3.small"
#   desired_capacity = 3
#   min_size         = 3
#   max_size         = 6
#   subnets          = ["subnet-0aeebfca3d1a6da83", "subnet-0e407d26b34566b16"] # Region subnet(s)

#   node_labels = {
#     "node.kubernetes.io/node-group" = "node-group-a" # (Optional) node-group name label
#   }
# }