output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_node_group_arns" {
  description = "ARNs of all managed node groups"
  value       = module.eks.eks_managed_node_group_arns
}

output "eks_node_group_names" {
  description = "Names of all managed node groups"
  value       = module.eks.eks_managed_node_group_names
}