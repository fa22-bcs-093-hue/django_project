# AWS Cleanup Script for Manual Resources
# Run this to clean up resources that Terraform can't destroy

Write-Host "`n🧹 AWS Resource Cleanup Script" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

$region = "eu-north-1"

# Check if AWS CLI is available
$awsInstalled = Get-Command aws -ErrorAction SilentlyContinue
if (-not $awsInstalled) {
    Write-Host "❌ AWS CLI not installed. Manual cleanup required:" -ForegroundColor Red
    Write-Host "`n1. Go to AWS Console: https://console.aws.amazon.com/" -ForegroundColor Yellow
    Write-Host "2. Switch to region: eu-north-1" -ForegroundColor Yellow
    Write-Host "`n3. Delete these resources manually:" -ForegroundColor Yellow
    Write-Host "   - EC2 → Key Pairs → Delete: django-dev-deployer-key" -ForegroundColor White
    Write-Host "   - IAM → Roles → Delete: django-dev-eks-cluster-role" -ForegroundColor White
    Write-Host "   - IAM → Roles → Delete: django-dev-eks-nodes-role" -ForegroundColor White
    Write-Host "   - RDS → Subnet Groups → Delete: django-dev-db-subnet-group" -ForegroundColor White
    Write-Host "   - S3 → Buckets → Empty and Delete: django-dev-storage-dev" -ForegroundColor White
    Write-Host "   - S3 → Buckets → Empty and Delete: django-dev-static-dev" -ForegroundColor White
    Write-Host "   - S3 → Buckets → Empty and Delete: django-dev-backups-dev" -ForegroundColor White
    Write-Host "`nPress Enter after manual cleanup to continue..." -ForegroundColor Green
    Read-Host
    exit
}

Write-Host "✅ AWS CLI found. Attempting automatic cleanup...`n" -ForegroundColor Green

# Delete EC2 Key Pair
Write-Host "🔑 Deleting EC2 Key Pair..." -ForegroundColor Yellow
try {
    aws ec2 delete-key-pair --key-name "django-dev-deployer-key" --region $region 2>$null
    Write-Host "   ✅ Key Pair deleted" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  Key Pair not found or already deleted" -ForegroundColor Gray
}

# Delete IAM Roles
Write-Host "`n👤 Deleting IAM Roles..." -ForegroundColor Yellow

# Detach policies from eks-cluster-role
$clusterPolicies = @(
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
)
foreach ($policy in $clusterPolicies) {
    try {
        aws iam detach-role-policy --role-name "django-dev-eks-cluster-role" --policy-arn $policy 2>$null
    } catch {}
}

# Delete cluster role
try {
    aws iam delete-role --role-name "django-dev-eks-cluster-role" 2>$null
    Write-Host "   ✅ EKS Cluster Role deleted" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  EKS Cluster Role not found" -ForegroundColor Gray
}

# Detach policies from eks-nodes-role
$nodesPolicies = @(
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
)
foreach ($policy in $nodesPolicies) {
    try {
        aws iam detach-role-policy --role-name "django-dev-eks-nodes-role" --policy-arn $policy 2>$null
    } catch {}
}

# Delete nodes role
try {
    aws iam delete-role --role-name "django-dev-eks-nodes-role" 2>$null
    Write-Host "   ✅ EKS Nodes Role deleted" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  EKS Nodes Role not found" -ForegroundColor Gray
}

# Delete RDS Subnet Group
Write-Host "`n🗄️  Deleting RDS DB Subnet Group..." -ForegroundColor Yellow
try {
    aws rds delete-db-subnet-group --db-subnet-group-name "django-dev-db-subnet-group" --region $region 2>$null
    Write-Host "   ✅ DB Subnet Group deleted" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  DB Subnet Group not found" -ForegroundColor Gray
}

# Delete S3 Buckets
Write-Host "`n🪣 Deleting S3 Buckets..." -ForegroundColor Yellow

$buckets = @(
    "django-dev-storage-dev",
    "django-dev-static-dev",
    "django-dev-backups-dev"
)

foreach ($bucket in $buckets) {
    try {
        # Empty bucket first
        Write-Host "   Emptying bucket: $bucket..." -ForegroundColor Gray
        aws s3 rm "s3://$bucket" --recursive --region $region 2>$null
        
        # Delete bucket
        aws s3api delete-bucket --bucket $bucket --region $region 2>$null
        Write-Host "   ✅ Bucket deleted: $bucket" -ForegroundColor Green
    } catch {
        Write-Host "   ⚠️  Bucket not found: $bucket" -ForegroundColor Gray
    }
}

Write-Host "`n✅ Cleanup complete!" -ForegroundColor Green
Write-Host "`nYou can now run: terraform apply" -ForegroundColor Cyan
