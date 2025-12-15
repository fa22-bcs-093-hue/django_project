# Manual Step Required Before Completing Task 2

## Issue

The RDS DB Subnet Group `django-dev-db-subnet-group` exists from a previous VPC and needs to be deleted.

## Steps to Fix

### Option 1: AWS Console (Recommended)

1. Go to https://console.aws.amazon.com
2. Sign in with: **talhaasad5584@gmail.com**
3. Switch region to **eu-north-1** (Europe Stockholm)
4. Go to **RDS** service
5. Click **Subnet groups** in left sidebar
6. Select `django-dev-db-subnet-group`
7. Click **Delete** button
8. Confirm deletion

### After Deletion

Run this command in PowerShell:

```powershell
cd e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\infra
$env:Path += ";$env:USERPROFILE\terraform"
terraform apply -auto-approve
```

This will create:

- ✅ VPC and networking (already created)
- ✅ EC2 instance (already created)
- ✅ S3 buckets (already created)
- ⏳ RDS database (will be created after subnet group deletion)

**Estimated time**: 2 minutes to delete + 10 minutes for RDS creation
