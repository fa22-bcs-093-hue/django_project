# AWS Console Screenshots Checklist

After terraform apply completes, take these 6 screenshots:

## Screenshot 1: VPC Dashboard

**Location**: VPC → Your VPCs

- Show VPC ID: vpc-02387aa95b30cbee5
- Show CIDR block: 10.0.0.0/16
- Show 4 subnets
- **Filename**: `1_vpc_dashboard.png`

## Screenshot 2: EC2 Instance

**Location**: EC2 → Instances

- Show instance ID: i-05d5a9e4cdc5cb72b
- Show instance type: t3.micro
- Show status: Running
- Show public IP address
- **Filename**: `2_ec2_instance.png`

## Screenshot 3: RDS Database

**Location**: RDS → Databases

- Show DB identifier: django-dev-postgres
- Show instance class: db.t3.micro
- Show status: Available
- Show endpoint address
- **Filename**: `3_rds_database.png`

## Screenshot 4: S3 Buckets

**Location**: S3 → Buckets

- Show all 3 buckets:
  - django-dev-storage-dev
  - django-dev-static-dev
  - django-dev-backups-dev
- Show versioning enabled
- **Filename**: `4_s3_buckets.png`

## Screenshot 5: Security Groups

**Location**: EC2 → Security Groups

- Show all 5 security groups:
  - django-dev-alb-sg
  - django-dev-ec2-sg
  - django-dev-rds-sg
  - django-dev-eks-cluster-sg
  - django-dev-eks-nodes-sg
- **Filename**: `5_security_groups.png`

## Screenshot 6: Terraform Output

**Location**: PowerShell Terminal

- Show output of: `terraform output`
- Must show all resource IDs, IPs, and endpoints
- **Filename**: `6_terraform_output.png`

## Where to Save

Save all screenshots in:

```
Task2_Deliverables/3_aws_console_screenshots/
```

## After Screenshots

Notify me and I'll run `terraform destroy` to clean up all resources.
