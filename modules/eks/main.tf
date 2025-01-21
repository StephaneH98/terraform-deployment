module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id                   = var.vpc_id
  subnet_ids              = var.private_subnets
  control_plane_subnet_ids = var.public_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 3

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = var.environment
      }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# Permettre au cluster d'accéder à ECR
resource "aws_iam_role_policy_attachment" "eks_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = module.eks.cluster_iam_role_name
}
