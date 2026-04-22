terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}


provider "aws" {
  # Configuration options
  region = var.region
}



data "aws_eks_cluster" "example" {
  name = "eks-cluster"
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.example.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority.0.data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.example.name]
      command     = "aws"
    }
  }
}
