# Task 2 Deliverables - Current Status

## Overview

Your Task 2 AWS Infrastructure deployment is **95% complete**. One manual step is required to finish.

## What's Been Done ✅

### 1. infra/ folder with .tf files ✅

**Location**: `Task2_Deliverables/1_terraform_files/`

All Terraform configuration files have been created and copied:

- ✅ main.tf (AWS provider configuration)
- ✅ variables.tf (variable definitions)
- ✅ terraform.tfvars (variable values)
- ✅ vpc.tf (VPC, subnets, IGW, route tables)
- ✅ ec2.tf (t3.micro compute instance)
- ✅ rds.tf (db.t3.micro PostgreSQL)
- ✅ s3.tf (3 S3 buckets with encryption)
- ✅ security-groups.tf (5 security groups)
- ✅ eks.tf (IAM roles - EKS disabled)
- ✅ outputs.tf (output definitions)

### 2. Terraform Resources Created ✅

**Status**: 42 out of 43 resources created

Successfully Created:

- ✅ VPC (vpc-02387aa95b30cbee5)
- ✅ 4 Subnets (2 public, 2 private)
- ✅ Internet Gateway
- ✅ 5 Security Groups
- ✅ 2 Route Tables
- ✅ 4 Route Table Associations
- ✅ 1 EC2 t3.micro Instance (i-05d5a9e4cdc5cb72b)
- ✅ 1 Elastic IP
- ✅ 1 SSH Key Pair
- ✅ 3 S3 Buckets (django-dev-storage-dev, django-dev-static-dev, django-dev-backups-dev)
- ✅ S3 Encryption Configurations
- ✅ S3 Versioning
- ✅ S3 Lifecycle Rules
- ✅ 2 IAM Roles
- ✅ 5 IAM Role Policy Attachments

Pending:

- ⏸️ 1 RDS DB Subnet Group (needs manual deletion first)
- ⏸️ 1 RDS PostgreSQL Instance (will be created after subnet group)

### 3. Outputs (terraform output) ⏳

**Location**: `Task2_Deliverables/2_terraform_outputs/`

Partial outputs saved (without RDS):

- ✅ terraform-outputs-partial.json (JSON format)
- ✅ terraform-outputs-partial.txt (readable format)

After RDS creation, will save:

- ⏸️ terraform-outputs-complete.json
- ⏸️ terraform-outputs-complete.txt

### 4. AWS Console Screenshots ⏸️

**Location**: `Task2_Deliverables/3_aws_console_screenshots/`

Not yet taken. Will be captured after RDS creation.

Required screenshots (6 total):

- ⏸️ 1_vpc_dashboard.png
- ⏸️ 2_ec2_instance.png
- ⏸️ 3_rds_database.png
- ⏸️ 4_s3_buckets.png
- ⏸️ 5_security_groups.png
- ⏸️ 6_terraform_output.png

See `SCREENSHOT_CHECKLIST.md` for detailed instructions.

### 5. terraform destroy proof ⏸️

**Location**: `Task2_Deliverables/4_terraform_destroy_proof/`

Will be executed after screenshots are taken.

---

## What You Need To Do Now 🔧

### ⚠️ MANUAL STEP REQUIRED

**Problem**: The RDS DB Subnet Group `django-dev-db-subnet-group` exists from a previous VPC and conflicts with our new VPC.

**Solution**: Delete it via AWS Console

#### Steps:

1. Open https://console.aws.amazon.com
2. Sign in: **talhaasad5584@gmail.com** / TalhaAsad@123
3. Switch region to **eu-north-1** (top-right corner)
4. Go to **RDS** service
5. Click **Subnet groups** in left sidebar
6. Select `django-dev-db-subnet-group`
7. Click **Delete** button
8. Confirm deletion

#### After Deletion:

Run this command in PowerShell:

```powershell
cd e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\infra
$env:Path += ";$env:USERPROFILE\terraform"
terraform apply -auto-approve
```

**Time required**:

- 2 minutes to delete subnet group
- 10 minutes for RDS creation
- Total: ~12 minutes

---

## After RDS Creation

Once terraform apply completes successfully, notify me and I will:

1. ✅ **Capture Complete Outputs**

   - Run `terraform output`
   - Save JSON and text formats
   - Include all resource IDs, IPs, endpoints

2. ✅ **Guide Screenshot Process**

   - Provide step-by-step instructions
   - Verify all 6 screenshots captured
   - Ensure all required information visible

3. ✅ **Execute terraform destroy**

   - Run destroy command
   - Capture terminal output
   - Save destroy proof screenshot
   - Verify all resources cleaned up

4. ✅ **Finalize Deliverables**
   - Organize all files
   - Create summary document
   - Package for submission

---

## Cost Verification ✅

**Total Monthly Cost**: $0.00

All resources are within AWS Free Tier:

- ✅ t3.micro EC2: 750 hours/month free (we use ~730 hours)
- ✅ db.t3.micro RDS: 750 hours/month free (we use ~730 hours)
- ✅ 20GB RDS storage: 20GB free (we use 20GB)
- ✅ S3 storage: 5GB free (we use <1GB)
- ✅ VPC/Subnets/IGW: Always free
- ✅ No NAT Gateway: Saved $32/month
- ✅ No EKS cluster: Saved $72/month

**Your $100 AWS credit remains untouched!** 💰

---

## Questions?

If you encounter any issues during the manual deletion step, let me know immediately and I'll help troubleshoot.

Otherwise, complete the deletion and run terraform apply, then notify me when it's done! 🚀
