# Development Environment Configuration - 100% FREE TIER (NO COST)
aws_region     = "eu-north-1"
project_name   = "django-dev"
environment    = "dev"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["eu-north-1a", "eu-north-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# Database Configuration (Free Tier: db.t3.micro, 750 hrs/month)
db_username = "django_admin"
db_password = "ChangeMe123!SecurePassword"  # Change this!
db_name     = "django_db"

# EKS Configuration (DISABLED - Costs $72/month!)
enable_eks               = false
eks_cluster_name         = "django-eks-cluster"
eks_node_instance_types  = ["t3.small"]
eks_desired_capacity     = 2
eks_min_capacity         = 1
eks_max_capacity         = 3

# EC2 Configuration (FREE TIER: t3.micro in eu-north-1, 750 hrs/month)
ec2_instance_type = "t3.micro"  # Changed back to t3.micro (t2.micro not available in eu-north-1)
ec2_instance_count = 1          # 1 instance to stay within 750 hours

# Security
allowed_ssh_cidr = ["0.0.0.0/0"]  # Change to your IP: ["YOUR_IP/32"]
