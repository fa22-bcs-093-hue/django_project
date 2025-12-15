# Task 3 - Deploy to Kubernetes (Quick Commands)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Task 3: Deploy Django to Kubernetes" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Wait for Docker build if needed
Write-Host "Checking Docker image..." -ForegroundColor Yellow
docker images django-drf-app

# Deploy to Kubernetes
Write-Host "`nDeploying to Kubernetes...`n" -ForegroundColor Yellow

Write-Host "1. Creating ConfigMap..." -ForegroundColor White
kubectl apply -f k8s/configmap.yaml

Write-Host "2. Creating Secret..." -ForegroundColor White  
kubectl apply -f k8s/secret.yaml

Write-Host "3. Creating Deployment..." -ForegroundColor White
kubectl apply -f k8s/deployment.yaml

Write-Host "4. Creating Service..." -ForegroundColor White
kubectl apply -f k8s/service.yaml

Write-Host "`nWaiting for pods to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=django-app --timeout=300s

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Deployment Status:" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

kubectl get all

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✅ Task 3 COMPLETE!" -ForegroundColor Green  
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Access app: kubectl port-forward service/django-app-service 8000:80" -ForegroundColor Yellow
Write-Host "Then open: http://localhost:8000`n" -ForegroundColor Yellow
