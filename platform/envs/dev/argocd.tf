# Kubernetes provider using existing kubeconfig
provider "kubernetes" {
  config_path = "/tmp/kubeconfig"
}

# Helm provider will automatically use the Kubernetes provider
provider "helm" {}

# Helm release for ArgoCD
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
}