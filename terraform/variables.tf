variable "region" {
  type        = string
  description = "AWS region to deploy EKS"
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "my-eks-cluster"
}