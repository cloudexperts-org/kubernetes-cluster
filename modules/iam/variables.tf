variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

# modules/iam/variables.tf
variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_arn" {
  type = string
}