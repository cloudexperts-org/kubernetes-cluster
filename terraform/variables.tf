variable "region" {
  type        = string
  description = "AWS region to deploy EKS"
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
}