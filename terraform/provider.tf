terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    
      helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
      }
  }
}


provider "helm" {
  kubernetes = {
    config_paths = [
      "/modules/kubernetes/app/templates/deployments.yaml",
      "/path/to/config_b.yaml"
    ]
  }
} 

provider "aws" {
  # Configuration options
  region = var.region
}


# terraform {
#   required_providers {
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = "3.0.1"
#     }
#   }
# }

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}