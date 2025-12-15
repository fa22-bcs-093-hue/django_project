# ============================================
# Input Variables
# ============================================

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "django-drf-project"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "django_admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!SecurePassword"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "django_db"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "django-eks-cluster"
}

variable "eks_node_instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.small"]  # Free tier eligible
}

variable "eks_desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "eks_min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "eks_max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "enable_eks" {
  description = "Enable EKS cluster (true) or use EC2 fallback (false)"
  type        = bool
  default     = true
}

variable "ec2_instance_type" {
  description = "EC2 instance type for fallback option"
  type        = string
  default     = "t3.micro"  # t3.micro is free tier in eu-north-1 (t2.micro not available)
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to create (when EKS is disabled)"
  type        = number
  default     = 1  # 1 instance to stay within 750 hours/month
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this to your IP for security
}
