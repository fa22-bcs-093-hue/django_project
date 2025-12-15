# Task 3 - Deploy Django to Kubernetes (PowerShell Alternative)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Task 3: Kubernetes Deployment with Automation" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Step 1: Install Dependencies
Write-Host "[Step 1/3] Installing Dependencies..." -ForegroundColor Yellow

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor White
docker --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not installed!" -ForegroundColor Red
    exit 1
}

# Check Kubernetes
Write-Host "Checking Kubernetes..." -ForegroundColor White
kubectl version --client
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Kubectl is not installed!" -ForegroundColor Red
    exit 1
}

# Check cluster
Write-Host "Checking Kubernetes cluster..." -ForegroundColor White
kubectl cluster-info
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Kubernetes cluster is not running!" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Dependencies OK`n" -ForegroundColor Green

# Step 2: Build Docker Image
Write-Host "[Step 2/3] Building Docker Image..." -ForegroundColor Yellow

$imageName = "django-drf-app"
$imageTag = "latest"
$fullImageName = "${imageName}:${imageTag}"

Write-Host "Building image: $fullImageName" -ForegroundColor White
docker build -t $fullImageName ..

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Docker image built successfully`n" -ForegroundColor Green

# Step 3: Deploy to Kubernetes
Write-Host "[Step 3/3] Deploying to Kubernetes..." -ForegroundColor Yellow

# Create ConfigMap
Write-Host "Creating ConfigMap..." -ForegroundColor White
kubectl create configmap django-config `
    --from-literal=DJANGO_SETTINGS_MODULE=config.settings.production `
    --from-literal=DATABASE_NAME=django_db `
    --from-literal=ALLOWED_HOSTS="*" `
    --dry-run=client -o yaml | kubectl apply -f -

# Create Secret
Write-Host "Creating Secret..." -ForegroundColor White
kubectl create secret generic django-secrets `
    --from-literal=SECRET_KEY=your-secret-key-here-change-in-production `
    --from-literal=DATABASE_PASSWORD=postgres123 `
    --dry-run=client -o yaml | kubectl apply -f -

# Create Deployment
Write-Host "Creating Deployment..." -ForegroundColor White
$deploymentYaml = @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: django-app
  labels:
    app: django-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: django-app
  template:
    metadata:
      labels:
        app: django-app
    spec:
      containers:
      - name: django
        image: django-drf-app:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 8000
        envFrom:
        - configMapRef:
            name: django-config
        - secretRef:
            name: django-secrets
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
"@

$deploymentYaml | kubectl apply -f -

# Create Service
Write-Host "Creating Service..." -ForegroundColor White
$serviceYaml = @"
apiVersion: v1
kind: Service
metadata:
  name: django-app-service
spec:
  type: LoadBalancer
  selector:
    app: django-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
"@

$serviceYaml | kubectl apply -f -

Write-Host "`n✅ Deployment complete!`n" -ForegroundColor Green

# Show status
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Kubernetes Resources:" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Pods:" -ForegroundColor Yellow
kubectl get pods

Write-Host "`nServices:" -ForegroundColor Yellow
kubectl get services

Write-Host "`nDeployments:" -ForegroundColor Yellow
kubectl get deployments

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Task 3 Complete! ✅" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nAccess your app at: http://localhost" -ForegroundColor Yellow
Write-Host "Or run: kubectl port-forward service/django-app-service 8000:80`n" -ForegroundColor Yellow
