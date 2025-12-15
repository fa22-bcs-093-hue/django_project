# Task 2: Terraform AWS Infrastructure - Quick Guide

## 📋 Overview

This folder contains Terraform configuration to provision a complete AWS infrastructure for the Django application.

## 🏗️ Infrastructure Components

### Network Layer

- **VPC**: Custom VPC (10.0.0.0/16) with DNS enabled
- **Subnets**: 2 public + 2 private subnets across 2 availability zones
- **Internet Gateway**: For public internet access
- **NAT Gateways**: 2 NAT gateways (one per AZ) for private subnet internet access
- **Route Tables**: Separate routing for public and private subnets

### Compute Layer

- **EKS Cluster**: Kubernetes v1.31 cluster
- **Node Group**: t3.small instances (2-4 nodes, 20GB disk)
- **IAM Roles**: Cluster and node group roles with required policies
- **Add-ons**: VPC-CNI, kube-proxy, CoreDNS

### Storage Layer

- **RDS PostgreSQL**: v15.5, db.t3.micro, 20GB storage, encrypted
- **S3 Buckets**:
  - Application storage (versioned, encrypted)
  - Static files (versioned, encrypted)
  - Backups (30-day lifecycle, encrypted)

### Security Layer

- **5 Security Groups**:
  - Web tier (HTTP/HTTPS)
  - App tier (internal communication)
  - Database tier (PostgreSQL access)
  - EKS cluster
  - EKS nodes

## 🚀 Usage Commands

### Prerequisites

```powershell
# Ensure Terraform is in PATH
$env:Path += ";$env:USERPROFILE\terraform"

# Verify AWS credentials
aws sts get-caller-identity

# Navigate to infra directory
cd e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\infra
```

### Basic Workflow

#### 1. Initialize (Already Done ✅)

```powershell
terraform init
```

#### 2. Validate Configuration (Already Done ✅)

```powershell
terraform validate
```

#### 3. Preview Changes

```powershell
terraform plan
# Or save the plan:
terraform plan -out=tfplan
```

#### 4. Create Infrastructure

```powershell
# Apply the saved plan
terraform apply tfplan

# Or apply directly (will ask for confirmation)
terraform apply
```

**⏱️ Expected Duration**: 15-20 minutes (EKS cluster takes longest)

#### 5. View Outputs

```powershell
# Show all outputs
terraform output

# Show specific output
terraform output eks_cluster_endpoint

# Save outputs to file
terraform output > terraform-output.txt
```

#### 6. Destroy Infrastructure

```powershell
terraform destroy
# Type 'yes' when prompted
```

## 💰 Cost Estimation

### Monthly Costs (Approximate)

- **EKS Cluster**: $73/month (control plane)
- **EKS Nodes** (2x t3.small): ~$30/month
- **RDS** (db.t3.micro): ~$15/month
- **NAT Gateways** (2x): ~$65/month
- **Data Transfer**: Variable
- **S3 Storage**: Minimal

**Total**: ~$180-200/month

### Free Tier Eligible

- ✅ 750 hours/month EC2 t2.micro/t3.micro (first 12 months)
- ✅ 750 hours/month RDS db.t2.micro/db.t3.micro (first 12 months)
- ✅ 5GB S3 storage
- ❌ EKS not free tier eligible

**⚠️ Important**: You have $100 AWS credit. Destroy resources after testing!

## 📸 Screenshots Needed for Task 2

### 1. VPC Dashboard

- Navigate to: AWS Console → VPC → Your VPCs
- Screenshot showing:
  - VPC ID and CIDR block (10.0.0.0/16)
  - 4 subnets (2 public, 2 private)
  - Internet Gateway
  - NAT Gateways

### 2. EKS Dashboard

- Navigate to: AWS Console → EKS → Clusters
- Screenshot showing:
  - Cluster name: django-dev-eks
  - Status: Active
  - Kubernetes version: 1.31
  - Node group details

### 3. RDS Dashboard

- Navigate to: AWS Console → RDS → Databases
- Screenshot showing:
  - Database identifier: django-dev-db
  - Engine: PostgreSQL 15.5
  - Status: Available
  - Instance size: db.t3.micro

### 4. S3 Buckets

- Navigate to: AWS Console → S3
- Screenshot showing all 3 buckets:
  - django-dev-app-storage
  - django-dev-static-files
  - django-dev-backups

### 5. Security Groups

- Navigate to: AWS Console → EC2 → Security Groups
- Screenshot showing 5 security groups with names

### 6. Terraform Outputs

- Screenshot of terminal after running:
  ```powershell
  terraform output
  ```

### 7. Terraform Destroy Proof

- Screenshot of terminal showing:
  ```powershell
  terraform destroy
  # Output showing: "Destroy complete! Resources: XX destroyed."
  ```

## 🔧 Helper Script

Use the interactive helper script:

```powershell
.\terraform-helper.ps1
```

## 📝 Configuration Files

| File                 | Purpose                            |
| -------------------- | ---------------------------------- |
| `main.tf`            | Provider configuration             |
| `variables.tf`       | Input variables                    |
| `terraform.tfvars`   | Variable values                    |
| `vpc.tf`             | VPC and networking                 |
| `security-groups.tf` | Security groups                    |
| `eks.tf`             | EKS cluster and nodes              |
| `rds.tf`             | PostgreSQL database                |
| `s3.tf`              | S3 buckets                         |
| `ec2.tf`             | Fallback EC2 (disabled by default) |
| `outputs.tf`         | Output values                      |

## 🔐 Security Notes

1. **Database Password**: Change `db_password` in `terraform.tfvars`
2. **Secrets**: Never commit `terraform.tfvars` to git (already in `.gitignore`)
3. **State File**: Contains sensitive data, protect `terraform.tfstate`
4. **SSH Keys**: Auto-generated for EC2 (if enabled), stored as `deployer-key.pem`

## 🐛 Troubleshooting

### Issue: "Error: creating VPC..."

**Solution**: Check AWS credentials and region in `~/.aws/config`

### Issue: "Error: creating EKS Cluster: InvalidParameterException"

**Solution**: Verify subnet IDs and security group configurations

### Issue: "timeout while waiting for state to become 'ACTIVE'"

**Solution**: EKS creation takes 10-15 minutes, be patient

### Issue: "Error acquiring the state lock"

**Solution**: Another terraform process is running, or state is locked. Wait or force unlock:

```powershell
terraform force-unlock <lock-id>
```

## 🔗 Useful AWS CLI Commands

```powershell
# Verify authentication
aws sts get-caller-identity

# List VPCs
aws ec2 describe-vpcs --region eu-north-1

# List EKS clusters
aws eks list-clusters --region eu-north-1

# Get EKS kubeconfig
aws eks update-kubeconfig --region eu-north-1 --name django-dev-eks

# List RDS instances
aws rds describe-db-instances --region eu-north-1

# List S3 buckets
aws s3 ls
```

## 📊 Task 2 Deliverables Checklist

- [x] Infrastructure as Code: All `.tf` files created
- [ ] `terraform plan` output: Saved or screenshot
- [ ] `terraform apply`: Successfully executed
- [ ] `terraform output`: Screenshot showing all resource IDs/endpoints
- [ ] AWS Console Screenshots:
  - [ ] VPC and subnets
  - [ ] EKS cluster
  - [ ] RDS database
  - [ ] S3 buckets
  - [ ] Security groups
- [ ] `terraform destroy`: Screenshot showing resources destroyed
- [ ] Documentation: This guide + README.md

## 🎯 Next Steps

1. ✅ Terraform configuration validated
2. ⏳ Run `terraform plan` to preview resources
3. 🚀 Run `terraform apply` to create infrastructure (15-20 min)
4. 📸 Take AWS Console screenshots
5. 📄 Save `terraform output` to file
6. 🗑️ Run `terraform destroy` after documentation
7. 📋 Compile screenshots and outputs for submission

---

**Created**: $(Get-Date -Format "yyyy-MM-dd HH:mm")
**Terraform Version**: 1.14.2
**AWS Region**: eu-north-1
