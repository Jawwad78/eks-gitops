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


provider "aws" {
  # Configuration options
  region = var.region
}

