# Get the EKS cluster info
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# Kubernetes provider for accessing aws-auth ConfigMap
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# aws-auth ConfigMap
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      # GitHub Actions runner role
      {
        rolearn  = "arn:aws:iam::865809098262:role/GitHubRunnerRole"  # <-- replace with your GitHub Runner role ARN
        username = "github"
        groups   = ["system:masters"]
      },

      # 2EKS Node IAM role (managed node group)
      {
        rolearn  = "arn:aws:iam::865809098262:role/my-eks-node-role"  # <-- replace with your node IAM role ARN
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers","system:nodes"]
      }
    ])
  }

  depends_on = [module.eks]
}