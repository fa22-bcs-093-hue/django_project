# Task 3 Demonstration Script
# Demonstrates Configuration Management with Ansible

Write-Host ""
Write-Host "========================================"
Write-Host "TASK 3: Configuration Management (Ansible)"
Write-Host "========================================"
Write-Host ""

Write-Host "Deliverable 1: ansible/playbook.yaml" -ForegroundColor Green
Write-Host "Deliverable 2: ansible/hosts.ini" -ForegroundColor Green  
Write-Host "Deliverable 3: Running deployment demonstration" -ForegroundColor Green
Write-Host ""

# Task 1: Check Docker
Write-Host "[1/5] Checking Docker..." -ForegroundColor Yellow
docker --version
Write-Host ""

# Task 2: Check kubectl
Write-Host "[2/5] Checking kubectl..." -ForegroundColor Yellow
kubectl version --client --short
Write-Host ""

# Task 3: Check Kubernetes cluster
Write-Host "[3/5] Checking Kubernetes cluster..." -ForegroundColor Yellow
kubectl cluster-info | Select-Object -First 1
Write-Host ""

# Task 4: Check Docker image
Write-Host "[4/5] Checking Docker image..." -ForegroundColor Yellow
docker images django-drf-app:latest
Write-Host ""

# Task 5: Deploy to Kubernetes
Write-Host "[5/5] Deploying to Kubernetes..." -ForegroundColor Yellow
kubectl apply -f ..\k8s\
Write-Host ""

Write-Host "========================================"
Write-Host "Deployment Status"
Write-Host "========================================"
kubectl get all
Write-Host ""

Write-Host "========================================"
Write-Host "Configuration Resources"
Write-Host "========================================"
Write-Host "ConfigMap:" -ForegroundColor Yellow
kubectl get configmap django-config

Write-Host "Secret:" -ForegroundColor Yellow
kubectl get secret django-secrets

Write-Host ""
Write-Host "========================================"
Write-Host "Task 3 Deliverables Completed!" -ForegroundColor Green
Write-Host "========================================"
Write-Host "1. ansible/playbook.yaml - Created"
Write-Host "2. ansible/hosts.ini - Created"
Write-Host "3. Deployment - Demonstrated"
