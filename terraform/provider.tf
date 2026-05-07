terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.42.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }

     kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.1.0"
    }
  }
}


provider "aws" {
  # Configuration options
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks.aws_eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.aws_eks_cluster_certificate_authority)
  token                  = module.eks.aws_eks_cluster_token
}

provider "kubectl" {
  host                   = module.eks.aws_eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.aws_eks_cluster_certificate_authority)
  load_config_file       = false
  token                  = module.eks.aws_eks_cluster_token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.aws_eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.aws_eks_cluster_certificate_authority)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.aws_eks_cluster_name]
      command     = "aws"
    }
  }
}
