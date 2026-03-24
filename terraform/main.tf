provider "aws" {
  region = "ap-southeast-1"
}

#######################################
# VPC (basic example)
#######################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

#######################################
# EKS Cluster
#######################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.3.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.35"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = true
  cluster_endpoint_public_access_cidrs  = ["0.0.0.0/0"]

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
    }
  }

  #######################################
  # ✅ NEW AUTH METHOD (v20+)
  #######################################
  access_entries = {
    github-actions = {
      principal_arn = "arn:aws:iam::865809098262:user/akash"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

#######################################
# EKS Data Sources (for Kubernetes provider)
#######################################
data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

#######################################
# Kubernetes Provider
#######################################
provider "kubernetes" {
  host = module.eks.cluster_endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.cluster.certificate_authority[0].data
  )

  token = data.aws_eks_cluster_auth.cluster.token
}

#######################################
# Outputs
#######################################
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}