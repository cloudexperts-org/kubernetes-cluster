provider "aws" {
  region = "ap-southeast-1"
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