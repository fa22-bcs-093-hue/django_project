# Terraform Plan Summary - Task 2

**Date**: December 14, 2025  
**AWS Region**: eu-north-1  
**Project**: django-drf-project  
**Status**: ✅ Plan Successful - Ready to Apply

---

## 📊 Resources to be Created: 47

### 1. **VPC & Networking (15 resources)**

- **VPC**: `10.0.0.0/16` with DNS hostnames enabled
- **Public Subnets**: 2 subnets (`10.0.1.0/24`, `10.0.2.0/24`) in AZs eu-north-1a, eu-north-1b
- **Private Subnets**: 2 subnets (`10.0.11.0/24`, `10.0.12.0/24`) in AZs eu-north-1a, eu-north-1b
- **Internet Gateway**: For public internet access
- **NAT Gateways**: 2 NAT gateways (one per AZ) for private subnet internet access
- **Elastic IPs**: 2 EIPs for NAT gateways
- **Route Tables**: Public and private route tables with proper associations

### 2. **EKS Kubernetes Cluster (12 resources)**

- **EKS Cluster**: `django-eks-cluster`
  - Version: 1.31
  - Endpoint: Public access enabled
  - VPC Config: Across 2 private subnets
- **EKS Node Group**:
  - Instance Type: t3.small
  - Capacity: 2-4 nodes (desired: 2)
  - AMI Type: AL2_x86_64
  - Disk Size: 20 GB
- **IAM Roles**:
  - EKS cluster role with AmazonEKSClusterPolicy
  - Node group role with AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly
- **EKS Add-ons**:
  - vpc-cni (v1.18.1-eksbuild.1)
  - kube-proxy (v1.31.0-eksbuild.5)
  - coredns (v1.11.3-eksbuild.1)

### 3. **RDS PostgreSQL Database (3 resources)**

- **DB Instance**:
  - Engine: PostgreSQL 15.5
  - Instance Class: db.t3.micro (Free Tier eligible)
  - Storage: 20 GB gp3 (max 100 GB)
  - Database Name: `django_db`
  - Multi-AZ: No (for cost savings)
  - Backup: 7 days retention
  - Encryption: Enabled
- **DB Subnet Group**: Across 2 private subnets
- **Security Group**: PostgreSQL port 5432 access from EKS nodes and EC2

### 4. **S3 Storage (3 buckets)**

- **App Storage Bucket**: `django-drf-app-storage-[unique-id]`
  - Versioning: Enabled
  - Encryption: AES256
  - Lifecycle: Transition to IA after 90 days, Glacier after 180 days
- **Static Files Bucket**: `django-drf-static-files-[unique-id]`
  - Versioning: Enabled
  - Encryption: AES256
  - Lifecycle: Transition to IA after 90 days
- **Backups Bucket**: `django-drf-backups-[unique-id]`
  - Versioning: Enabled
  - Encryption: AES256
  - Lifecycle: Transition to Glacier after 30 days, delete after 365 days

### 5. **Security Groups (5 groups)**

- **EKS Cluster SG**: HTTPS (443) access from anywhere
- **EKS Nodes SG**: All traffic between nodes, HTTPS to cluster
- **EC2 SG**: SSH (22), HTTP (80), HTTPS (443) access
- **RDS SG**: PostgreSQL (5432) from EKS nodes and EC2
- **Cluster Communication SG**: Inter-node communication

### 6. **EC2 Instances (Optional - 0 created)**

- Configured but not created (count = 0)
- Can be enabled by changing `ec2_instance_count` in terraform.tfvars

---

## 📝 Configuration Values

```hcl
# From terraform.tfvars
project_name         = "django-drf-project"
environment          = "dev"
aws_region           = "eu-north-1"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["eu-north-1a", "eu-north-1b"]
enable_eks           = true
eks_cluster_version  = "1.31"
eks_node_instance_type = "t3.small"
rds_instance_class   = "db.t3.micro"
rds_engine_version   = "15.5"
rds_allocated_storage = 20
ec2_instance_count   = 0
```

---

## 💰 Estimated Monthly Costs (Free Tier)

⚠️ **Important**: Your AWS account has $100 in credits

| Resource                | Estimated Cost/Month |
| ----------------------- | -------------------- |
| EKS Control Plane       | $72                  |
| EKS Nodes (2x t3.small) | ~$30                 |
| RDS db.t3.micro         | ~$15 (Free Tier: $0) |
| NAT Gateways (2)        | ~$64                 |
| S3 Storage (minimal)    | ~$1                  |
| Data Transfer           | ~$5                  |
| **Total**               | **~$187/month**      |

**With Free Tier**: ~$172/month (your $100 credit covers first 15 days)

---

## 🎯 Outputs Available After Apply

```
vpc_id                    - VPC identifier
vpc_cidr                  - VPC CIDR block
public_subnet_ids         - Public subnet IDs
private_subnet_ids        - Private subnet IDs
eks_cluster_name          - EKS cluster name
eks_cluster_endpoint      - EKS API endpoint
eks_cluster_id            - EKS cluster ID
kubeconfig_command        - Command to configure kubectl
rds_endpoint              - RDS connection endpoint
rds_address               - RDS hostname
rds_database_name         - Database name
s3_app_storage_bucket     - App storage bucket name
s3_static_files_bucket    - Static files bucket name
s3_backups_bucket         - Backups bucket name
infrastructure_summary    - Complete infrastructure overview
```

---

## ⚡ Next Steps

### To Apply (Create Resources):

```powershell
cd e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\infra
$env:Path += ";$env:USERPROFILE\terraform"
terraform apply "tfplan"
```

**Creation Time**: ~15-20 minutes (mostly EKS cluster creation)

### To Get Outputs After Apply:

```powershell
terraform output
terraform output -json > terraform-outputs.json
```

### To Configure kubectl for EKS:

```powershell
aws eks update-kubeconfig --region eu-north-1 --name django-eks-cluster
kubectl get nodes
```

### To Destroy (Clean Up):

```powershell
terraform destroy
```

---

## 📸 Required Screenshots for Documentation

After `terraform apply` completes:

1. **AWS Console - VPC Dashboard**

   - Show VPC with CIDR 10.0.0.0/16
   - Show 4 subnets (2 public, 2 private)
   - Show Internet Gateway and NAT Gateways

2. **AWS Console - EKS Dashboard**

   - Show cluster `django-eks-cluster` status: Active
   - Show node group with 2 nodes
   - Show cluster version 1.31

3. **AWS Console - RDS Dashboard**

   - Show PostgreSQL instance
   - Show endpoint and port 5432
   - Show database name `django_db`

4. **AWS Console - S3 Dashboard**

   - Show 3 buckets created
   - Show versioning and encryption enabled

5. **Terminal - Terraform Outputs**

   - Run `terraform output` and screenshot

6. **Terminal - Terraform Destroy**
   - Run `terraform destroy` and screenshot "Destroy complete!" message

---

## 🔒 Security Features

✅ All S3 buckets have encryption enabled (AES256)  
✅ RDS database is encrypted at rest  
✅ RDS is in private subnets (no public access)  
✅ Security groups follow least privilege principle  
✅ VPC has proper network isolation  
✅ EKS nodes are in private subnets  
✅ IAM roles follow AWS best practices

---

## ⚠️ Important Notes

1. **Cost Management**:

   - EKS control plane costs $0.10/hour ($72/month) - **NOT FREE TIER**
   - NAT Gateways cost $0.045/hour each (~$32/month each)
   - Total cost will exceed your $100 credit after ~15 days
   - **Destroy resources after screenshots to avoid charges**

2. **Free Tier Benefits Used**:

   - RDS db.t3.micro (750 hours/month free)
   - S3 5GB storage free
   - Some data transfer free

3. **Credentials**:

   - Database password is in `terraform.tfvars` (change after creation)
   - RDS username is sensitive (shown as `(sensitive value)`)

4. **Terraform State**:
   - `terraform.tfstate` will be created after apply
   - **DO NOT commit state files to Git** (contains sensitive data)
   - `.gitignore` already configured to exclude state files

---

## ✅ Task 2 Requirements Checklist

- [x] VPC with subnets across multiple AZs
- [x] Security groups for all components
- [x] EKS cluster with node group
- [x] RDS PostgreSQL database
- [x] S3 buckets for storage
- [x] Outputs defined for all resources
- [x] Terraform init successful
- [x] Terraform plan successful (47 resources)
- [ ] Terraform apply (pending)
- [ ] AWS Console screenshots (pending)
- [ ] Terraform destroy proof (pending)

---

**Generated**: December 14, 2025  
**Terraform Version**: v1.14.2  
**AWS Provider Version**: v5.100.0  
**Plan File**: `tfplan` (binary)  
**Full Plan Output**: `terraform-plan-output.txt`
