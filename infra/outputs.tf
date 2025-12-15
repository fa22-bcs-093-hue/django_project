# ============================================
# VPC Outputs
# ============================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

# ============================================
# EKS Outputs
# ============================================

output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = var.enable_eks ? aws_eks_cluster.main[0].id : null
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = var.enable_eks ? aws_eks_cluster.main[0].endpoint : null
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.eks_cluster.id
}

output "eks_cluster_name" {
  description = "Kubernetes cluster name"
  value       = var.enable_eks ? aws_eks_cluster.main[0].name : null
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = var.enable_eks ? aws_eks_cluster.main[0].certificate_authority[0].data : null
  sensitive   = true
}

output "eks_node_group_id" {
  description = "EKS node group ID"
  value       = var.enable_eks ? aws_eks_node_group.main[0].id : null
}

output "eks_node_group_status" {
  description = "Status of the EKS node group"
  value       = var.enable_eks ? aws_eks_node_group.main[0].status : null
}

# ============================================
# RDS Outputs
# ============================================

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "RDS instance address"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.postgres.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.postgres.db_name
}

output "rds_username" {
  description = "RDS master username"
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

# ============================================
# S3 Outputs
# ============================================

output "s3_app_storage_bucket" {
  description = "Name of the S3 bucket for application storage"
  value       = aws_s3_bucket.app_storage.id
}

output "s3_app_storage_arn" {
  description = "ARN of the S3 bucket for application storage"
  value       = aws_s3_bucket.app_storage.arn
}

output "s3_static_files_bucket" {
  description = "Name of the S3 bucket for static files"
  value       = aws_s3_bucket.static_files.id
}

output "s3_backups_bucket" {
  description = "Name of the S3 bucket for backups"
  value       = aws_s3_bucket.backups.id
}

# ============================================
# EC2 Outputs (Fallback)
# ============================================

output "ec2_instance_ids" {
  description = "IDs of EC2 instances"
  value       = var.enable_eks ? [] : aws_instance.app_server[*].id
}

output "ec2_public_ips" {
  description = "Public IPs of EC2 instances"
  value       = var.enable_eks ? [] : aws_eip.app_server[*].public_ip
}

output "ec2_private_ips" {
  description = "Private IPs of EC2 instances"
  value       = var.enable_eks ? [] : aws_instance.app_server[*].private_ip
}

# ============================================
# Security Group Outputs
# ============================================

output "eks_cluster_security_group" {
  description = "Security group ID for EKS cluster"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_security_group" {
  description = "Security group ID for EKS nodes"
  value       = aws_security_group.eks_nodes.id
}

output "rds_security_group" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}

output "ec2_security_group" {
  description = "Security group ID for EC2 instances"
  value       = aws_security_group.ec2_instance.id
}

# ============================================
# Connection Information
# ============================================

output "kubeconfig_command" {
  description = "Command to configure kubectl"
  value       = var.enable_eks ? "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main[0].name}" : "EKS not enabled"
}

output "database_connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${aws_db_instance.postgres.username}:${var.db_password}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"
  sensitive   = true
}

# ============================================
# Summary Output
# ============================================

output "infrastructure_summary" {
  description = "Summary of created infrastructure"
  value = {
    region              = var.aws_region
    project_name        = var.project_name
    environment         = var.environment
    vpc_id              = aws_vpc.main.id
    eks_enabled         = var.enable_eks
    eks_cluster_name    = var.enable_eks ? aws_eks_cluster.main[0].name : "N/A"
    rds_endpoint        = aws_db_instance.postgres.endpoint
    s3_storage_bucket   = aws_s3_bucket.app_storage.id
    s3_static_bucket    = aws_s3_bucket.static_files.id
    s3_backups_bucket   = aws_s3_bucket.backups.id
    ec2_instance_count  = var.enable_eks ? 0 : length(aws_instance.app_server)
  }
}
