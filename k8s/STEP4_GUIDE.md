# Step 4: Kubernetes Deployment Guide

## Overview

This directory contains all required Kubernetes manifests to deploy the Django DRF application to Kubernetes (Docker Desktop local cluster).

## Required Manifests (All Present)

### ✅ 1. deployment.yaml

- Django application deployment with 2 replicas
- Resource limits and requests configured
- Health checks ready
- Environment variables from ConfigMap and Secret

### ✅ 2. service.yaml

- LoadBalancer service exposing port 80
- Routes traffic to Django pods on port 8000
- Accessible at http://localhost/

### ✅ 3. configmap.yaml

- Non-sensitive configuration data
- Django settings module
- Database connection parameters
- Allowed hosts configuration

### ✅ 4. secret.yaml

- Sensitive data (base64 encoded)
- Django SECRET_KEY
- Database passwords

### ✅ 5. postgres-deployment.yaml (NEW)

- PostgreSQL database for Django
- Persistent storage
- Health checks

### ✅ 6. postgres-service.yaml (NEW)

- Internal ClusterIP service
- Accessible only within cluster

## Architecture

```
┌─────────────────────────────────────────┐
│         LoadBalancer Service            │
│         (localhost:80)                  │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      Django App Deployment              │
│      (2 replicas)                       │
│      - Pod 1: django-app-xxx            │
│      - Pod 2: django-app-yyy            │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      PostgreSQL Service (ClusterIP)     │
│      postgres-service:5432              │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      PostgreSQL Deployment              │
│      (1 replica with PVC)               │
└─────────────────────────────────────────┘
```

## Deployment Steps

### Step 1: Verify Docker Desktop Kubernetes

```powershell
kubectl cluster-info
kubectl get nodes
```

### Step 2: Deploy PostgreSQL Database

```powershell
# Apply PostgreSQL manifests
kubectl apply -f k8s/postgres-pvc.yaml
kubectl apply -f k8s/postgres-deployment.yaml
kubectl apply -f k8s/postgres-service.yaml

# Wait for PostgreSQL to be ready
kubectl wait --for=condition=ready pod -l app=postgres --timeout=60s
```

### Step 3: Deploy ConfigMap and Secrets

```powershell
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
```

### Step 4: Deploy Django Application

```powershell
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Wait for deployment
kubectl rollout status deployment/django-app
```

### Step 5: Run Database Migrations

```powershell
# Get a pod name
$POD = kubectl get pod -l app=django-app -o jsonpath="{.items[0].metadata.name}"

# Run migrations
kubectl exec -it $POD -- python manage.py migrate

# Create superuser (optional)
kubectl exec -it $POD -- python manage.py createsuperuser
```

### Step 6: Verify Deployment

```powershell
# Check all resources
kubectl get all

# Check pods are running
kubectl get pods

# Check logs
kubectl logs -l app=django-app --tail=50

# Test the application
curl http://localhost/api/
```

## Quick Deploy (All at Once)

```powershell
# Deploy everything
kubectl apply -f k8s/

# Wait for PostgreSQL
Start-Sleep -Seconds 10

# Wait for Django
kubectl wait --for=condition=ready pod -l app=django-app --timeout=120s

# Run migrations
$POD = kubectl get pod -l app=django-app -o jsonpath="{.items[0].metadata.name}"
kubectl exec -it $POD -- python manage.py migrate

# Check status
kubectl get all
```

## Verification Commands

```powershell
# View all resources
kubectl get all

# View ConfigMaps
kubectl get configmap django-config -o yaml

# View Secrets (encoded)
kubectl get secret django-secrets -o yaml

# View pod logs
kubectl logs -l app=django-app --tail=100

# View pod details
kubectl describe pod -l app=django-app

# Test database connection
$POD = kubectl get pod -l app=django-app -o jsonpath="{.items[0].metadata.name}"
kubectl exec -it $POD -- python manage.py check --database default
```

## Troubleshooting

### Pods in CrashLoopBackOff

```powershell
# Check logs
kubectl logs -l app=django-app --tail=100

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Describe pod
kubectl describe pod -l app=django-app
```

### Database Connection Issues

```powershell
# Check PostgreSQL is running
kubectl get pod -l app=postgres

# Check PostgreSQL logs
kubectl logs -l app=postgres

# Test connection from Django pod
$POD = kubectl get pod -l app=django-app -o jsonpath="{.items[0].metadata.name}"
kubectl exec -it $POD -- env | grep DATABASE
```

### Service Not Accessible

```powershell
# Check service
kubectl get svc django-app-service

# Check endpoints
kubectl get endpoints django-app-service

# Port forward if LoadBalancer not working
kubectl port-forward svc/django-app-service 8080:80
# Then access at http://localhost:8080
```

## Cleanup

```powershell
# Delete all resources
kubectl delete -f k8s/

# Or delete individually
kubectl delete deployment django-app
kubectl delete service django-app-service
kubectl delete configmap django-config
kubectl delete secret django-secrets
kubectl delete deployment postgres
kubectl delete service postgres-service
kubectl delete pvc postgres-pvc
```

## File Manifest Summary

| File                     | Type                  | Purpose                     |
| ------------------------ | --------------------- | --------------------------- |
| configmap.yaml           | ConfigMap             | Non-sensitive configuration |
| secret.yaml              | Secret                | Sensitive credentials       |
| deployment.yaml          | Deployment            | Django application pods     |
| service.yaml             | Service               | External LoadBalancer       |
| postgres-pvc.yaml        | PersistentVolumeClaim | Database storage            |
| postgres-deployment.yaml | Deployment            | PostgreSQL database         |
| postgres-service.yaml    | Service               | Internal database service   |

## Environment Variables

### From ConfigMap (django-config)

- `DJANGO_SETTINGS_MODULE`: Production settings
- `DATABASE_NAME`: Database name
- `DATABASE_HOST`: PostgreSQL service hostname
- `DATABASE_PORT`: PostgreSQL port
- `ALLOWED_HOSTS`: Allowed host headers

### From Secret (django-secrets)

- `SECRET_KEY`: Django secret key
- `DATABASE_PASSWORD`: PostgreSQL password
- `DATABASE_USER`: PostgreSQL username

## Health Checks

### Liveness Probe

- Checks if container is running
- Restarts container if fails

### Readiness Probe

- Checks if container can accept traffic
- Removes from service endpoints if fails

## Resource Limits

### Django Application

- Memory: 256Mi request, 512Mi limit
- CPU: 250m request, 500m limit

### PostgreSQL

- Memory: 256Mi request, 512Mi limit
- CPU: 250m request, 500m limit

## Next Steps

1. ✅ Deploy PostgreSQL database
2. ✅ Deploy Django application
3. ✅ Run migrations
4. ⏳ Create superuser
5. ⏳ Test API endpoints
6. ⏳ Take screenshots for submission
