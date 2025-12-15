# 🎯 FREE TIER AWS Infrastructure - Complete Guide

## ✅ What Changed from Original Plan

### Original Configuration (NOT Free Tier):

- ❌ EKS Cluster: **$72/month**
- ❌ 2x NAT Gateways: **$64/month**
- ✅ 2x EKS Nodes (t3.small): $30/month
- ✅ RDS db.t3.micro: Free tier (750 hrs)
- ✅ S3 Buckets: Free tier (5GB)
  **Total: ~$187/month** (Exceeds your $100 credit!)

### NEW Free-Tier Optimized Configuration:

- ✅ **EKS DISABLED** (Saves $72/month)
- ✅ **2x EC2 t3.micro** (Free tier: 750 hrs/month)
- ✅ **1x NAT Gateway** (Saves $32/month, now $32 total)
- ✅ RDS db.t3.micro (Free tier: 750 hrs)
- ✅ S3 Buckets (Free tier: 5GB)
- ✅ VPC + Subnets (Free)
  **Estimated: $32-40/month** (Well within your $100 credit for 2-3 months!)

## 💰 Detailed Cost Breakdown (Per Month)

| Resource       | Configuration  | Monthly Cost | Free Tier       |
| -------------- | -------------- | ------------ | --------------- |
| EC2 Instances  | 2x t3.micro    | $0           | ✅ 750 hrs      |
| RDS PostgreSQL | 1x db.t3.micro | $0           | ✅ 750 hrs      |
| NAT Gateway    | 1x NAT         | $32          | ❌ Not eligible |
| S3 Storage     | <5GB           | $0           | ✅ 5GB free     |
| Data Transfer  | <1GB/month     | $0           | ✅ 1GB free     |
| EBS Volumes    | 40GB (2x20GB)  | $0           | ✅ 30GB free    |
| **TOTAL**      |                | **~$32-40**  |                 |

### Your $100 Credit Coverage:

- **Months covered**: 2.5-3 months
- **Safe operation time**: You can keep this running for weeks!

---

## 📦 What Will Be Created

### 1. **Network Infrastructure** (FREE)

- 1x VPC (10.0.0.0/16)
- 2x Public Subnets (10.0.1.0/24, 10.0.2.0/24)
- 2x Private Subnets (10.0.11.0/24, 10.0.12.0/24)
- 1x Internet Gateway
- 1x NAT Gateway ($32/month)
- 1x Elastic IP for NAT
- Route Tables & Associations

**Resources: ~15**

### 2. **Compute Layer** (FREE TIER)

- 2x EC2 t3.micro instances (Amazon Linux 2)
- Auto-assigned public IPs
- SSH key pair (auto-generated)
- Located in public subnets

**Resources: ~5**

### 3. **Database Layer** (FREE TIER)

- 1x RDS PostgreSQL 15.5
- Instance: db.t3.micro
- Storage: 20GB GP3
- Located in private subnets
- Automated backups (7 days)

**Resources: ~3**

### 4. **Storage Layer** (FREE TIER)

- 3x S3 Buckets:
  - django-dev-app-storage
  - django-dev-static-files
  - django-dev-backups
- All with encryption & versioning

**Resources: ~12**

### 5. **Security** (FREE)

- 5x Security Groups:
  - EC2 instances (SSH, HTTP, HTTPS)
  - RDS database (PostgreSQL 5432)
  - EKS cluster (disabled but configured)
  - EKS nodes (disabled but configured)
  - Cluster communication

**Resources: ~5**

**TOTAL RESOURCES: ~40** (down from 47)

---

## 🚀 Step-by-Step Deployment Guide

### **Step 1: Initialize Terraform**

```powershell
cd e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\infra
$env:Path += ";$env:USERPROFILE\terraform"
terraform init
```

**Status**: ✅ Complete

### **Step 2: Validate Configuration**

```powershell
terraform validate
```

**Status**: ✅ Complete

### **Step 3: Review Plan**

```powershell
terraform plan
```

**Expected output**: ~40 resources to add
**Status**: ⏳ Running now...

### **Step 4: Apply Configuration**

```powershell
terraform apply
# Type 'yes' when prompted
```

**Duration**: 10-15 minutes (RDS creation takes longest)
**Status**: ⏸️ Pending

### **Step 5: Save Outputs**

```powershell
terraform output
terraform output > terraform-outputs.txt
terraform output -json > terraform-outputs.json
```

**Status**: ⏸️ Pending

---

## 📸 Screenshot Guide for Documentation

After `terraform apply` completes, take these screenshots:

### 1. **AWS Console - VPC Dashboard**

Navigate to: **AWS Console → VPC → Your VPCs**

**Show**:

- VPC ID with CIDR 10.0.0.0/16
- Name: django-dev-vpc
- DNS hostnames: Enabled

Navigate to: **VPC → Subnets**

**Show**:

- 4 subnets total
- 2 public (10.0.1.0/24, 10.0.2.0/24)
- 2 private (10.0.11.0/24, 10.0.12.0/24)

Navigate to: **VPC → NAT Gateways**

**Show**:

- 1 NAT Gateway
- Status: Available
- Elastic IP attached

### 2. **AWS Console - EC2 Dashboard**

Navigate to: **AWS Console → EC2 → Instances**

**Show**:

- 2 running instances
- Instance type: t3.micro
- Public IP addresses
- Status: Running

Navigate to: **EC2 → Key Pairs**

**Show**:

- django-dev-deployer-key

### 3. **AWS Console - RDS Dashboard**

Navigate to: **AWS Console → RDS → Databases**

**Show**:

- Database identifier: django-dev-db
- Engine: PostgreSQL 15.5
- Status: Available
- Instance class: db.t3.micro
- Storage: 20 GB
- Multi-AZ: No

### 4. **AWS Console - S3 Dashboard**

Navigate to: **AWS Console → S3**

**Show**:

- 3 buckets:
  - django-dev-app-storage-[id]
  - django-dev-static-files-[id]
  - django-dev-backups-[id]
- Versioning: Enabled
- Encryption: Enabled

### 5. **AWS Console - Security Groups**

Navigate to: **AWS Console → EC2 → Security Groups**

**Show**:

- django-dev-ec2-sg
- django-dev-rds-sg
- All with inbound/outbound rules

### 6. **Terminal - Terraform Outputs**

Screenshot of:

```powershell
terraform output
```

Showing:

- VPC ID
- Subnet IDs
- EC2 public IPs
- RDS endpoint
- S3 bucket names

### 7. **Terminal - Terraform Destroy**

After all screenshots, run:

```powershell
terraform destroy
# Type 'yes' when prompted
```

Screenshot showing:

- "Destroy complete! Resources: XX destroyed."

---

## 🔧 How to Use the Infrastructure

### Connect to EC2 Instances via SSH:

```powershell
# Get the private key
$keyPath = "e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\infra\deployer-key.pem"

# Get EC2 public IP from outputs
terraform output

# SSH (use Git Bash or WSL)
ssh -i deployer-key.pem ec2-user@<PUBLIC_IP>
```

### Connect to RDS Database:

```powershell
# Get RDS endpoint
terraform output rds_endpoint

# Connect using psql (from EC2 instance or local with VPN)
psql -h <RDS_ENDPOINT> -U django_admin -d django_db
```

### Deploy Django Application:

```bash
# On EC2 instance
sudo yum update -y
sudo yum install -y python3 python3-pip git postgresql

# Clone your Django project
git clone https://github.com/<your-repo>/django-project.git
cd django-project

# Install dependencies
pip3 install -r requirements.txt

# Set environment variables
export DATABASE_URL=postgresql://django_admin:ChangeMe123!SecurePassword@<RDS_ENDPOINT>:5432/django_db
export DJANGO_SETTINGS_MODULE=config.settings.production

# Run migrations
python3 manage.py migrate

# Collect static files (upload to S3)
python3 manage.py collectstatic --noinput

# Start application
python3 manage.py runserver 0.0.0.0:8000
```

---

## 🛡️ Security Best Practices

### ✅ Implemented:

- Private subnets for RDS (no public access)
- Security groups with least privilege
- S3 bucket encryption (AES256)
- RDS encryption at rest
- Separate security groups for each tier
- Auto-generated SSH keys (not in source control)

### ⚠️ TODO Before Production:

1. **Change Database Password**:

   - Update `db_password` in `terraform.tfvars`
   - Run `terraform apply` to update

2. **Restrict SSH Access**:

   - Update `allowed_ssh_cidr` to your IP only
   - Change from `["0.0.0.0/0"]` to `["YOUR_IP/32"]`

3. **Enable VPC Flow Logs**:

   ```hcl
   resource "aws_flow_log" "main" {
     iam_role_arn    = aws_iam_role.flow_log.arn
     log_destination = aws_cloudwatch_log_group.flow_log.arn
     traffic_type    = "ALL"
     vpc_id          = aws_vpc.main.id
   }
   ```

4. **Use AWS Secrets Manager**:

   - Store database credentials in Secrets Manager
   - Reference in Terraform

5. **Enable CloudWatch Alarms**:
   - CPU utilization
   - Disk space
   - Network traffic

---

## 📋 Task 2 Deliverables Checklist

### ✅ Completed:

- [x] `infra/` folder with all `.tf` files
- [x] Free-tier optimized configuration
- [x] Documentation and guides
- [x] terraform init successful
- [x] terraform validate successful

### ⏳ In Progress:

- [x] terraform plan (running now)

### ⏸️ Pending:

- [ ] terraform apply
- [ ] terraform output saved
- [ ] AWS Console screenshots (7 required)
- [ ] terraform destroy proof

---

## 🔍 Troubleshooting

### Issue: "Error: creating VPC..."

**Solution**: Check AWS credentials are set correctly

### Issue: "Error: insufficient capacity"

**Solution**: Try different availability zone or instance type

### Issue: "Error: DB instance already exists"

**Solution**: Use different DB identifier or destroy previous

### Issue: SSH key permission denied

**Solution**:

```powershell
# In Git Bash or WSL
chmod 600 deployer-key.pem
```

### Issue: Can't connect to RDS from local machine

**Solution**: RDS is in private subnet. Options:

1. Connect from EC2 instance
2. Set up VPN or bastion host
3. Temporarily allow your IP in security group

---

## 💡 Tips for Free Tier

1. **Monitor Usage**:

   - AWS Console → Billing → Free Tier
   - Check monthly usage to avoid charges

2. **Stop/Start EC2 Instances**:

   ```powershell
   # Stop instances when not using
   aws ec2 stop-instances --instance-ids <INSTANCE_ID>

   # Start when needed
   aws ec2 start-instances --instance-ids <INSTANCE_ID>
   ```

3. **RDS Snapshots**:

   - Before destroying, create snapshot
   - Restore later without losing data

4. **S3 Lifecycle**:

   - Already configured to move old files to cheaper storage
   - Automatically deletes backups after 30 days

5. **Set Billing Alerts**:
   - AWS Console → CloudWatch → Billing
   - Create alarm for $5, $10, $20 thresholds

---

## 📚 Additional Resources

- **Terraform AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **AWS Free Tier**: https://aws.amazon.com/free/
- **RDS Best Practices**: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html
- **VPC Guide**: https://docs.aws.amazon.com/vpc/latest/userguide/

---

**Generated**: December 14, 2025  
**Configuration**: Free Tier Optimized  
**Estimated Monthly Cost**: $32-40  
**Your Credit**: $100 (covers 2.5-3 months)
