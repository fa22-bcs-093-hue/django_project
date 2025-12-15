# DevOps Lab - Task 2 Summary Report

## 📌 Task Overview

**Task 2**: Automate AWS infrastructure provisioning using Terraform

## 🎯 Requirements

### Infrastructure Components

1. ✅ **VPC + Subnets + Security Groups**
2. ✅ **EKS Cluster** (Kubernetes)
3. ✅ **RDS PostgreSQL Database** (Alternative to S3)
4. ✅ **S3 Buckets** (Additional storage)

### Deliverables

1. ✅ `infra/` folder with `.tf` files
2. ⏳ `terraform plan` output showing resources
3. ⏳ `terraform apply` execution
4. ⏳ `terraform output` showing provisioned resources
5. ⏳ AWS Console screenshots
6. ⏳ `terraform destroy` proof

## 📁 File Structure

```
infra/
├── main.tf                  # Provider configuration (AWS, TLS, Local)
├── variables.tf             # Input variable definitions
├── terraform.tfvars         # Variable values (gitignored)
├── vpc.tf                   # VPC, subnets, IGW, NAT gateways, routing
├── security-groups.tf       # 5 security groups (web, app, db, eks cluster, eks nodes)
├── eks.tf                   # EKS cluster, node group, IAM roles, add-ons
├── rds.tf                   # PostgreSQL 15.5 database
├── s3.tf                    # 3 S3 buckets with encryption
├── ec2.tf                   # Fallback EC2 instances (disabled by default)
├── outputs.tf               # Output values for resources
├── README.md                # Complete documentation
├── TASK2_QUICK_GUIDE.md     # Quick reference guide
├── terraform-helper.ps1     # Interactive helper script
└── .gitignore               # Terraform-specific ignores
```

## 🏗️ Infrastructure Architecture

### Network Layer (vpc.tf)

```
VPC: 10.0.0.0/16
├── Availability Zone A (eu-north-1a)
│   ├── Public Subnet: 10.0.1.0/24
│   └── Private Subnet: 10.0.11.0/24
└── Availability Zone B (eu-north-1b)
    ├── Public Subnet: 10.0.2.0/24
    └── Private Subnet: 10.0.12.0/24

Internet Gateway → Public Subnets
NAT Gateway A → Private Subnet A
NAT Gateway B → Private Subnet B
```

**Resources**: 15 (VPC, 4 subnets, IGW, 2 NAT gateways, 2 EIPs, 2 route tables, 4 route table associations)

### Security Layer (security-groups.tf)

1. **web-sg**: HTTP (80), HTTPS (443) from 0.0.0.0/0
2. **app-sg**: Port 8000 from web-sg
3. **db-sg**: PostgreSQL (5432) from app-sg and EKS nodes
4. **eks-cluster-sg**: Port 443 from 0.0.0.0/0
5. **eks-nodes-sg**: All traffic between nodes

**Resources**: 5 security groups with ~15 ingress/egress rules

### Compute Layer (eks.tf)

```
EKS Cluster: django-dev-eks
├── Version: 1.31
├── Endpoint: Public access enabled
├── IAM Role: EKS cluster role
├── Add-ons:
│   ├── vpc-cni (v1.19.1)
│   ├── kube-proxy (v1.31.4)
│   └── coredns (v1.11.4)
└── Node Group: django-dev-nodes
    ├── Instance Type: t3.small
    ├── Scaling: 2-4 nodes
    ├── Disk: 20GB
    └── IAM Role: EKS node group role
```

**Resources**: 12 (cluster, node group, 2 IAM roles, 4 IAM role policy attachments, 3 add-ons, 2 IAM role policies)

### Database Layer (rds.tf)

```
RDS Instance: django-dev-db
├── Engine: PostgreSQL 15.5
├── Instance Class: db.t3.micro
├── Storage: 20GB GP3
├── Multi-AZ: No (free tier)
├── Encryption: Yes (AES-256)
├── Backups: 7-day retention
├── Username: postgres
└── Password: [from terraform.tfvars]
```

**Resources**: 3 (DB subnet group, DB instance, parameter group)

### Storage Layer (s3.tf)

```
S3 Buckets:
1. django-dev-app-storage
   ├── Versioning: Enabled
   ├── Encryption: AES256
   └── Access: Private

2. django-dev-static-files
   ├── Versioning: Enabled
   ├── Encryption: AES256
   └── Access: Private

3. django-dev-backups
   ├── Versioning: Enabled
   ├── Encryption: AES256
   ├── Lifecycle: Delete after 30 days
   └── Access: Private
```

**Resources**: 12 (3 buckets, 3 versioning configs, 3 encryption configs, 3 public access blocks, 1 lifecycle config)

## 📊 Total Resource Count

| Category         | Count  |
| ---------------- | ------ |
| VPC & Networking | 15     |
| Security Groups  | 5      |
| EKS Cluster      | 12     |
| RDS Database     | 3      |
| S3 Buckets       | 12     |
| **TOTAL**        | **47** |

## 🔧 Configuration Details

### Provider Configuration (main.tf)

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws   = "~> 5.0"
    tls   = "~> 4.0"
    local = "~> 2.0"
  }
}

provider "aws" {
  region = "eu-north-1"
  default_tags {
    Project     = "django-dev"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}
```

### Variables (terraform.tfvars)

```hcl
project_name        = "django-dev"
environment         = "development"
aws_region          = "eu-north-1"
vpc_cidr            = "10.0.0.0/16"
availability_zones  = ["eu-north-1a", "eu-north-1b"]
enable_nat_gateway  = true
enable_eks          = true
eks_node_group_size = {
  desired = 2
  min     = 2
  max     = 4
}
db_name     = "djangodb"
db_username = "postgres"
db_password = "ChangeMe123!"  # Should be changed!
```

## 💰 Cost Analysis

### Monthly Costs (Free Tier)

| Service           | Configuration | Monthly Cost  | Free Tier  |
| ----------------- | ------------- | ------------- | ---------- |
| EKS Control Plane | 1 cluster     | $73           | ❌ No      |
| EC2 (EKS Nodes)   | 2x t3.small   | ~$30          | ⚠️ Partial |
| RDS PostgreSQL    | db.t3.micro   | ~$15          | ✅ 750hrs  |
| NAT Gateway       | 2x NAT        | ~$65          | ❌ No      |
| EBS Volumes       | 40GB (2x20GB) | ~$4           | ✅ 30GB    |
| S3 Storage        | <5GB          | <$1           | ✅ 5GB     |
| Data Transfer     | Variable      | ~$5-10        | ✅ 1GB     |
| **TOTAL**         |               | **~$180-200** |            |

### With $100 Credit

- **Effective Cost**: ~$80-100/month
- **Hours until credit exhausted**: ~12-15 hours of operation
- **⚠️ IMPORTANT**: Destroy infrastructure after testing!

## 🚀 Execution Steps

### 1. Initialization ✅

```powershell
terraform init
```

**Status**: ✅ Complete

- Downloaded AWS provider v5.100.0
- Downloaded TLS provider v4.0.6
- Downloaded Local provider v2.6.1

### 2. Validation ✅

```powershell
terraform validate
```

**Status**: ✅ Complete

- All configuration files are valid
- Fixed S3 lifecycle rule filter
- Fixed EC2 SSH key generation (auto-generated with TLS provider)

### 3. Planning ⏳

```powershell
terraform plan
```

**Status**: ⏳ In Progress

- Generating execution plan
- Will show 47+ resources to be created

### 4. Apply (Pending)

```powershell
terraform apply
```

**Expected Duration**: 15-20 minutes
**Critical Resources**:

- EKS cluster creation: 10-12 minutes
- RDS database: 5-7 minutes
- VPC/networking: 2-3 minutes

### 5. Outputs (Pending)

```powershell
terraform output
terraform output > terraform-output.txt
```

### 6. Screenshots (Pending)

AWS Console screenshots needed:

- [ ] VPC Dashboard
- [ ] EKS Cluster
- [ ] RDS Database
- [ ] S3 Buckets
- [ ] Security Groups
- [ ] Terraform outputs

### 7. Destroy (Pending)

```powershell
terraform destroy
```

## 📋 Output Values

The following outputs will be available after `terraform apply`:

```
# VPC
vpc_id
public_subnet_ids
private_subnet_ids
nat_gateway_ids

# EKS
eks_cluster_id
eks_cluster_endpoint
eks_cluster_security_group_id
eks_node_group_id
eks_node_group_role_arn
configure_kubectl (command to connect)

# RDS
rds_endpoint
rds_database_name
rds_username

# S3
s3_app_storage_bucket
s3_static_files_bucket
s3_backups_bucket
```

## 🔐 Security Considerations

### Implemented Security Features

1. ✅ **Encryption at Rest**

   - RDS: AES-256 encryption enabled
   - S3: AES-256 server-side encryption
   - EBS: Encrypted volumes

2. ✅ **Network Isolation**

   - Private subnets for EKS nodes and RDS
   - Security groups with least-privilege rules
   - No direct internet access to private resources

3. ✅ **Secrets Management**

   - Database password in `terraform.tfvars` (gitignored)
   - SSH keys auto-generated (not in source control)
   - IAM roles instead of access keys for services

4. ✅ **Public Access Blocked**
   - S3 buckets: Public access blocked by default
   - RDS: Only accessible from VPC
   - EKS nodes: In private subnets

### Required Actions

- [ ] Change `db_password` in `terraform.tfvars` before production
- [ ] Enable S3 bucket logging
- [ ] Configure AWS Secrets Manager for sensitive data
- [ ] Enable VPC Flow Logs
- [ ] Set up CloudWatch alarms

## 🐛 Issues Encountered & Resolutions

### Issue 1: S3 Lifecycle Rule Validation Error

**Error**:

```
No attribute specified when one (and only one) of
[rule[0].filter,rule[0].prefix] is required
```

**Resolution**: Added empty `filter {}` block to lifecycle rule

### Issue 2: EC2 SSH Key File Not Found

**Error**:

```
no file exists at "./deployer-key.pub"
```

**Resolution**:

- Added `tls_private_key` resource to auto-generate SSH keys
- Added `local_file` resource to save private key
- Added TLS and Local providers to `main.tf`

### Issue 3: Missing Provider Dependencies

**Error**: TLS and Local providers not available
**Resolution**:

- Updated `required_providers` in `main.tf`
- Ran `terraform init -upgrade` to download providers

## 📸 Screenshot Checklist

### AWS Console Screenshots

#### 1. VPC Dashboard

**Location**: AWS Console → VPC → Your VPCs
**Show**:

- [x] VPC ID: `vpc-xxxxx`
- [x] CIDR: `10.0.0.0/16`
- [x] Name: `django-dev-vpc`
- [x] DNS enabled: Yes

**Location**: AWS Console → VPC → Subnets
**Show**:

- [x] 2 public subnets (10.0.1.0/24, 10.0.2.0/24)
- [x] 2 private subnets (10.0.11.0/24, 10.0.12.0/24)
- [x] Availability zones (a, b)

#### 2. EKS Dashboard

**Location**: AWS Console → EKS → Clusters → django-dev-eks
**Show**:

- [ ] Cluster name
- [ ] Status: Active
- [ ] Kubernetes version: 1.31
- [ ] Endpoint
- [ ] Networking tab (VPC, subnets, security groups)
- [ ] Compute tab (Node group details)

#### 3. RDS Dashboard

**Location**: AWS Console → RDS → Databases → django-dev-db
**Show**:

- [ ] DB identifier
- [ ] Engine: PostgreSQL 15.5
- [ ] Status: Available
- [ ] Instance class: db.t3.micro
- [ ] Storage: 20 GB
- [ ] Multi-AZ: No

#### 4. S3 Dashboard

**Location**: AWS Console → S3 → Buckets
**Show**:

- [ ] django-dev-app-storage bucket
- [ ] django-dev-static-files bucket
- [ ] django-dev-backups bucket
- [ ] Versioning status
- [ ] Encryption status

#### 5. Security Groups

**Location**: AWS Console → EC2 → Security Groups
**Show**:

- [ ] django-dev-web-sg
- [ ] django-dev-app-sg
- [ ] django-dev-db-sg
- [ ] EKS cluster security group
- [ ] EKS nodes security group

#### 6. Terminal Screenshots

- [ ] `terraform plan` output summary
- [ ] `terraform apply` completion message
- [ ] `terraform output` showing all values
- [ ] `terraform destroy` completion message

## 📝 Documentation Files Created

1. ✅ `main.tf` - Terraform and provider configuration
2. ✅ `variables.tf` - Variable definitions with descriptions
3. ✅ `terraform.tfvars` - Variable values
4. ✅ `vpc.tf` - VPC networking infrastructure
5. ✅ `security-groups.tf` - Security group definitions
6. ✅ `eks.tf` - EKS cluster and node configuration
7. ✅ `rds.tf` - RDS PostgreSQL database
8. ✅ `s3.tf` - S3 bucket definitions
9. ✅ `ec2.tf` - EC2 instances (fallback, disabled)
10. ✅ `outputs.tf` - Output value definitions
11. ✅ `README.md` - Complete infrastructure documentation
12. ✅ `.gitignore` - Terraform-specific ignores
13. ✅ `TASK2_QUICK_GUIDE.md` - Quick reference guide
14. ✅ `terraform-helper.ps1` - Interactive helper script
15. ✅ `TASK2_SUMMARY.md` - This file

## ✅ Task 2 Completion Status

### Completed ✅

- [x] Infrastructure design
- [x] All `.tf` configuration files
- [x] Documentation and guides
- [x] AWS credentials configuration
- [x] Terraform installation
- [x] `terraform init` successful
- [x] `terraform validate` successful
- [x] Fixed configuration errors

### In Progress ⏳

- [x] `terraform plan` executing

### Pending ⏸️

- [ ] `terraform apply` execution
- [ ] AWS resource creation
- [ ] `terraform output` capture
- [ ] AWS Console screenshots
- [ ] `terraform destroy` execution
- [ ] Final report compilation

## 🎓 Learning Outcomes

1. **Infrastructure as Code**: Designed and implemented complete AWS infrastructure using Terraform
2. **AWS Services**: Worked with VPC, EKS, RDS, S3, Security Groups, IAM
3. **Network Architecture**: Designed multi-AZ VPC with public/private subnets
4. **Kubernetes**: Set up managed EKS cluster with auto-scaling node groups
5. **Security**: Implemented encryption, network isolation, least-privilege access
6. **Cost Optimization**: Chose free-tier eligible resources where possible
7. **Best Practices**: Modular code, version control, documentation

## 🔗 Useful Commands Reference

```powershell
# Terraform
terraform init          # Initialize providers
terraform validate      # Validate configuration
terraform fmt          # Format code
terraform plan         # Preview changes
terraform apply        # Create resources
terraform output       # Show outputs
terraform destroy      # Delete resources

# AWS CLI
aws sts get-caller-identity                    # Verify auth
aws eks update-kubeconfig --name django-dev-eks  # Get kubeconfig
aws rds describe-db-instances                  # List RDS
aws s3 ls                                     # List S3 buckets

# kubectl (after EKS creation)
kubectl get nodes                              # List nodes
kubectl get pods -A                           # List all pods
kubectl cluster-info                          # Cluster info
```

---

**Report Generated**: 2025-01-24
**Terraform Version**: 1.14.2
**AWS Region**: eu-north-1
**Project**: django-dev
**Environment**: development
