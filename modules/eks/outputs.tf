output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_iam_role_name" {
  description = "IAM role name for the cluster"
  value       = module.eks.cluster_iam_role_name
}
