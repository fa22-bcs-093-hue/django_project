# Task 2: AWS Infrastructure with Terraform - Deliverables

## Deliverable Structure

```
Task2_Deliverables/
├── 1_terraform_files/          # All .tf configuration files
├── 2_terraform_outputs/        # terraform output results
├── 3_aws_console_screenshots/  # AWS Console screenshots
├── 4_terraform_destroy_proof/  # terraform destroy evidence
├── README.md                   # This file
└── MANUAL_STEP_REQUIRED.md     # Instructions for RDS subnet group deletion
```

## Status: 95% Complete ⏳

### ✅ Completed

- [x] All Terraform configuration files created (.tf files)
- [x] terraform init successful
- [x] terraform validate successful
- [x] terraform plan successful
- [x] VPC created (vpc-02387aa95b30cbee5)
- [x] 4 subnets created (2 public, 2 private)
- [x] Internet Gateway created
- [x] Security groups created (5 groups)
- [x] EC2 t3.micro instance created (i-05d5a9e4cdc5cb72b)
- [x] S3 buckets created (3 buckets with encryption)
- [x] IAM roles created (2 roles)

### ⏳ Pending - 1 Manual Step Required

- [ ] Delete old RDS subnet group via AWS Console
- [ ] Run terraform apply to create RDS database

### After Manual Step

Once you delete the RDS subnet group, run:

```powershell
cd e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\infra
$env:Path += ";$env:USERPROFILE\terraform"
terraform apply -auto-approve
```

Then I'll complete:

- [ ] Capture terraform outputs
- [ ] Take AWS Console screenshots
- [ ] Run terraform destroy
- [ ] Capture destroy proof

## Infrastructure Details

### 100% AWS Free Tier Configuration

- **Region**: eu-north-1 (Europe Stockholm)
- **Monthly Cost**: $0.00 (within free tier limits)

### Resources Created

1. **VPC**: 1 VPC with CIDR 10.0.0.0/16
2. **Subnets**: 4 subnets (2 public, 2 private) across 2 AZs
3. **EC2**: 1 t3.micro instance (750 hours/month free)
4. **RDS**: 1 db.t3.micro PostgreSQL (750 hours/month free)
5. **S3**: 3 buckets with encryption and versioning (5GB free)
6. **Security Groups**: 5 security groups for network isolation
7. **IAM**: 2 IAM roles for EKS (future use)

### Key Terraform Files

- `main.tf` - Provider configuration
- `variables.tf` - Variable definitions
- `terraform.tfvars` - Variable values
- `vpc.tf` - Network infrastructure
- `ec2.tf` - Compute instances
- `rds.tf` - PostgreSQL database
- `s3.tf` - Object storage
- `security-groups.tf` - Firewall rules
- `eks.tf` - IAM roles (EKS disabled to save $72/month)
- `outputs.tf` - Output values

## Instructions

### See MANUAL_STEP_REQUIRED.md for the next step

After completing the manual step, notify me and I'll:

1. Capture terraform outputs (JSON and text)
2. Guide you through taking 6 AWS Console screenshots
3. Run terraform destroy
4. Capture destroy proof screenshot
5. Organize all deliverables

**Estimated time to complete**: 15 minutes (2 min manual + 10 min RDS creation + 3 min screenshots)
