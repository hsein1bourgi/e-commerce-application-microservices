# # -----------------------------
# # EKS Cluster Outputs
# # -----------------------------
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_oidc_provider_arn" {
  description = "OIDC provider ARN for IAM roles"
  value       = module.eks.oidc_provider_arn
}

# # -----------------------------
# # ECR Repositories
# # -----------------------------
output "customer_ecr_repo_url" {
  description = "ECR repo URL for customer service"
  value       = aws_ecr_repository.customer.repository_url
}

output "products_ecr_repo_url" {
  description = "ECR repo URL for products service"
  value       = aws_ecr_repository.products.repository_url
}

output "shopping_ecr_repo_url" {
  description = "ECR repo URL for shopping service"
  value       = aws_ecr_repository.shopping.repository_url
}

# -----------------------------
# VPC Outputs
# -----------------------------
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}
