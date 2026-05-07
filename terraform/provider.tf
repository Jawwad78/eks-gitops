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
  }
}


provider "aws" {
  # Configuration options
  region = var.region
}



variable "aws_eks_cluster_endpoint" {
  type = string
}

variable "aws_eks_cluster_certificate_authority" {
  type = string

}

provider "helm" {
  kubernetes = {
    host                   = var.aws_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority.0.data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.example.name]
      command     = "aws"
    }
  }
}
