output "cluster_name" {
  value = module.this_eks.cluster_name
}

output "cluster_arn" {
  value = module.this_eks.cluster_arn
}


output "eks_managed_node_groups" {
  description = "Managed node group resources."
  value = aws_eks_node_group.this
}
