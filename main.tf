provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "kubernetes-application/terraform.tfstate"
    region = "eu-west-3"
  }
}

module "vpc" {
  source = "./modules/vpc"
  environment    = var.environment
  vpc_cidr      = var.vpc_cidr
  cluster_name  = var.cluster_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
}

module "ecr" {
  source = "./modules/ecr"

  environment = var.environment
  app_name    = "web-app"
}
