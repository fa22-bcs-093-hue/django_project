# Terraform Infrastructure - Task 2

## Overview

This Terraform configuration provisions AWS infrastructure for the Django DRF project including:

- VPC with public/private subnets
- EKS Kubernetes cluster
- RDS PostgreSQL database
- S3 buckets for storage
- Security groups and networking
- EC2 fallback option

## Prerequisites

✅ **Completed:**

- AWS Account created
- AWS credentials configured (`~/.aws/credentials`)
- Terraform installed (v1.14.2)

## Quick Start

### 1. Initialize Terraform

```powershell
cd infra
$env:Path += ";$env:USERPROFILE\terraform"
terraform init
```

### 2. Review Configuration

Edit `terraform.tfvars` to customize:

```hcl
db_password = "YOUR_SECURE_PASSWORD"
allowed_ssh_cidr = ["YOUR_IP/32"]
```

### 3. Plan Infrastructure

```powershell
terraform plan
```

This shows what will be created without making changes.

### 4. Apply Infrastructure

```powershell
# Create all resources
terraform apply

# Type 'yes' when prompted
```

**Note:** This will take 15-20 minutes (EKS cluster creation is slow).

### 5. View Outputs

```powershell
terraform output
```

## What Gets Created

### Networking

- ✅ **VPC** (10.0.0.0/16)
- ✅ **2 Public Subnets** (10.0.1.0/24, 10.0.2.0/24)
- ✅ **2 Private Subnets** (10.0.11.0/24, 10.0.12.0/24)
- ✅ **Internet Gateway**
- ✅ **2 NAT Gateways** (one per AZ)
- ✅ **Route Tables** (public & private)

### Compute

- ✅ **EKS Cluster** (Kubernetes 1.28)
- ✅ **EKS Node Group** (2 t3.small instances)
- ✅ **Auto Scaling** (1-3 nodes)

### Database

- ✅ **RDS PostgreSQL 15.5** (db.t3.micro)
- ✅ **20 GB storage**
- ✅ **Encrypted**
- ✅ **Automated backups** (7 days retention)

### Storage

- ✅ **S3 Bucket** - Application storage
- ✅ **S3 Bucket** - Static files
- ✅ **S3 Bucket** - Backups (30-day lifecycle)
- ✅ **Versioning enabled**
- ✅ **Encryption enabled**

### Security

- ✅ **5 Security Groups**:
  - EKS Cluster
  - EKS Nodes
  - RDS Database
  - EC2 Instances
  - Load Balancer
- ✅ **IAM Roles** for EKS

## Cost Estimate (Free Tier)

| Resource          | Cost (approx)               |
| ----------------- | --------------------------- |
| EKS Control Plane | $0.10/hour ($73/month)      |
| EC2 (2x t3.small) | $0.023/hour/instance        |
| RDS (db.t3.micro) | Free tier (750 hours/month) |
| NAT Gateway       | $0.045/hour (~$33/month)    |
| S3                | Free tier (5 GB)            |
| **Total**         | ~$120-150/month             |

**⚠️ WARNING:** Costs can add up quickly! Destroy resources when not needed.

## Important Commands

### View Current State

```powershell
terraform show
```

### View Specific Output

```powershell
terraform output eks_cluster_endpoint
terraform output rds_endpoint
terraform output s3_app_storage_bucket
```

### Update Infrastructure

```powershell
# After changing .tf files
terraform plan
terraform apply
```

### Destroy Everything

```powershell
terraform destroy

# Type 'yes' to confirm
```

## Connect to EKS Cluster

After infrastructure is created:

```powershell
# Configure kubectl
aws eks update-kubeconfig --region eu-north-1 --name django-eks-cluster

# Verify connection
kubectl get nodes
kubectl get pods --all-namespaces
```

## Connect to RDS Database

```powershell
# Get connection details
terraform output database_connection_string

# Example connection (from within VPC):
psql -h <rds-endpoint> -U django_admin -d django_db
```

## Fallback: Use EC2 Instead of EKS

If you want to save costs and use EC2 instead:

1. Edit `terraform.tfvars`:

   ```hcl
   enable_eks = false
   ```

2. Apply changes:
   ```powershell
   terraform apply
   ```

This will create 2 EC2 instances with Docker installed.

## File Structure

```
infra/
├── main.tf              # Provider & Terraform config
├── variables.tf         # Input variables
├── terraform.tfvars     # Variable values (customize this)
├── vpc.tf              # VPC, subnets, routing
├── security-groups.tf  # Security group rules
├── eks.tf              # EKS cluster & node group
├── rds.tf              # PostgreSQL database
├── s3.tf               # S3 buckets
├── ec2.tf              # EC2 fallback instances
├── outputs.tf          # Output values
└── README.md           # This file
```

## Troubleshooting

### Error: "Error creating EKS Cluster"

- Check AWS service quotas: https://console.aws.amazon.com/servicequotas/
- Ensure you have permissions to create EKS resources

### Error: "Insufficient capacity"

- Try different instance types or regions
- Use `t3.micro` instead of `t3.small`

### Error: "Credentials not found"

- Verify `~/.aws/credentials` exists
- Run: `cat "$env:USERPROFILE\.aws\credentials"`

### Terraform state locked

```powershell
# Force unlock (use carefully!)
terraform force-unlock <LOCK_ID>
```

## Security Best Practices

1. **Change default passwords** in `terraform.tfvars`
2. **Restrict SSH access** - Set `allowed_ssh_cidr` to your IP
3. **Enable MFA** on your AWS account
4. **Don't commit** `terraform.tfvars` or `terraform.tfstate`
5. **Use separate accounts** for dev/prod

## Screenshots for Task 2

After `terraform apply`, take screenshots of:

1. **AWS Console - VPC**

   - Go to: VPC → Your VPCs
   - Show created VPC

2. **AWS Console - EKS**

   - Go to: EKS → Clusters
   - Show cluster details

3. **AWS Console - RDS**

   - Go to: RDS → Databases
   - Show database instance

4. **AWS Console - S3**

   - Go to: S3 → Buckets
   - Show created buckets

5. **Terminal - Terraform Output**

   ```powershell
   terraform output > terraform-output.txt
   ```

6. **Terminal - Terraform Destroy**
   ```powershell
   terraform destroy
   # Screenshot the confirmation
   ```

## Next Steps

After infrastructure is created:

1. **Deploy application to EKS**:

   - Build Docker image
   - Push to ECR or Docker Hub
   - Create Kubernetes manifests
   - Deploy with kubectl

2. **Configure Django**:

   - Update settings with RDS endpoint
   - Configure S3 for static files
   - Set up environment variables

3. **Set up CI/CD**:
   - Update GitHub Actions
   - Add deployment to EKS

## Cleanup

**IMPORTANT:** Always destroy resources when done to avoid charges:

```powershell
cd infra
terraform destroy
```

Confirm by typing `yes`. This removes all AWS resources created by Terraform.

## Support

Common issues:

- EKS takes 15-20 minutes to create
- RDS takes 5-10 minutes to create
- NAT Gateway adds significant cost (~$33/month)
- Free tier limits apply

---

**Task 2 Deliverables:**

- ✅ `infra/` folder with .tf files
- ✅ `terraform output` showing resources
- ✅ Screenshots of AWS Console
- ✅ `terraform destroy` proof
