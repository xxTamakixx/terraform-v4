terraform {
  required_version = ">= 1.0"
  # backend "s3" {

  #   # TODO 自分のS3バケット名に置き換えます。
  #   # bucket = "my-bucket"
  #   # key    = "terraform.tfstate"
  #   # region = "ap-northeast-1"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
     kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.22.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
    config_path            = "~/.kube/config"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "aws" {
  region  = var.region
  profile = var.profile_name
}
