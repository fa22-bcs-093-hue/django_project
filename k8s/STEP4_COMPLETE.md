# Step 4: Kubernetes Deployment - COMPLETED ✅

## Deployment Summary

Successfully deployed Django DRF application to Kubernetes (Docker Desktop local cluster) with all required components.

## ✅ Required Manifests (All Present)

### 1. deployment.yaml ✅

**Location:** `k8s/deployment.yaml`

**Purpose:** Deploys Django application with 2 replicas

**Key Features:**

- 2 replicas for high availability
- Health checks (liveness and readiness probes)
- Resource limits (CPU and memory)
- Environment variables from ConfigMap and Secret
- Image pull policy: Never (uses local image)

**Configuration:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: django-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: django-app
  template:
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
```

### 2. service.yaml ✅

**Location:** `k8s/service.yaml`

**Purpose:** Exposes Django application externally

**Type:** LoadBalancer (accessible at http://localhost/)

**Configuration:**

```yaml
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
```

**Access URL:** http://localhost/api/

### 3. configmap.yaml ✅

**Location:** `k8s/configmap.yaml`

**Purpose:** Non-sensitive configuration data

**Data Included:**

- `DJANGO_SETTINGS_MODULE`: Production settings module
- `DATABASE_URL`: PostgreSQL connection string
- `DATABASE_NAME`: Database name (django_db)
- `DATABASE_HOST`: PostgreSQL service hostname
- `DATABASE_PORT`: PostgreSQL port (5432)
- `ALLOWED_HOSTS`: Allowed HTTP hosts (\*)

### 4. secret.yaml ✅

**Location:** `k8s/secret.yaml`

**Purpose:** Sensitive credentials (base64 encoded in cluster)

**Data Included:**

- `SECRET_KEY`: Django secret key
- `DATABASE_USER`: PostgreSQL username
- `DATABASE_PASSWORD`: PostgreSQL password

## 📦 Additional Components (Bonus)

### 5. PostgreSQL Database

Deployed a complete PostgreSQL database for Django:

**Files:**

- `postgres-pvc.yaml`: 1Gi persistent volume claim
- `postgres-deployment.yaml`: PostgreSQL 15 Alpine deployment
- `postgres-service.yaml`: Internal ClusterIP service

**Features:**

- Persistent storage (data survives pod restarts)
- Health checks (liveness and readiness probes)
- Resource limits
- Password from Kubernetes Secret

## 🚀 Deployment Results

### Current Status

```
NAME                             READY   STATUS    RESTARTS   AGE
pod/django-app-bf954895f-25wn9   1/1     Running   0          31s
pod/django-app-bf954895f-q5bkc   1/1     Running   0          32s
pod/postgres-74f5b8c9bb-mmbqc    1/1     Running   0          2m9s

NAME                         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)
service/django-app-service   LoadBalancer   10.108.13.200   localhost     80:30303/TCP
service/postgres-service     ClusterIP      10.97.225.210   <none>        5432/TCP

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/django-app   2/2     2            2           103s
deployment.apps/postgres     1/1     1            1           3m46s
```

### ✅ All Pods Running

- Django: 2/2 pods running
- PostgreSQL: 1/1 pod running

### ✅ Services Accessible

- Django API: http://localhost/api/ (LoadBalancer)
- PostgreSQL: postgres-service:5432 (Internal ClusterIP)

### ✅ Database Connected

- Migrations completed successfully
- Database tables created
- Application connected to PostgreSQL

### ✅ API Working

**Test Command:**

```powershell
curl http://localhost/api/
```

**Response:**

```json
{
  "message": "Django REST Framework API",
  "version": "1.0",
  "endpoints": {
    "app1": "/api/app1/",
    "app1_home": "/api/app1/home"
  }
}
```

## 📋 Deployment Steps Executed

### 1. Deploy PostgreSQL Database

```powershell
kubectl apply -f k8s/postgres-pvc.yaml
kubectl apply -f k8s/postgres-deployment.yaml
kubectl apply -f k8s/postgres-service.yaml
```

### 2. Deploy ConfigMap and Secret

```powershell
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
```

### 3. Deploy Django Application

```powershell
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### 4. Verify Deployment

```powershell
kubectl get all
kubectl get configmap
kubectl get secret
```

### 5. Test Application

```powershell
curl http://localhost/api/
```

## 🔍 Verification Commands

### Check All Resources

```powershell
kubectl get all
```

### Check Pods Status

```powershell
kubectl get pods
kubectl describe pod -l app=django-app
kubectl describe pod -l app=postgres
```

### Check Services

```powershell
kubectl get svc
kubectl describe svc django-app-service
```

### Check ConfigMap and Secret

```powershell
kubectl get configmap django-config -o yaml
kubectl get secret django-secrets -o yaml
```

### View Logs

```powershell
# Django logs
kubectl logs -l app=django-app --tail=50

# PostgreSQL logs
kubectl logs -l app=postgres --tail=50

# Follow logs in real-time
kubectl logs -l app=django-app -f
```

### Test Database Connection

```powershell
$POD = kubectl get pod -l app=django-app -o jsonpath="{.items[0].metadata.name}"
kubectl exec -it $POD -- python manage.py check --database default
```

### Access Pod Shell

```powershell
$POD = kubectl get pod -l app=django-app -o jsonpath="{.items[0].metadata.name}"
kubectl exec -it $POD -- /bin/bash
```

## 📊 Resource Configuration

### Django Application

- **Replicas:** 2
- **Image:** django-drf-app:latest
- **Port:** 8000
- **Memory:** 256Mi request, 512Mi limit
- **CPU:** 250m request, 500m limit

### PostgreSQL Database

- **Replicas:** 1
- **Image:** postgres:15-alpine
- **Port:** 5432
- **Storage:** 1Gi persistent volume
- **Memory:** 256Mi request, 512Mi limit
- **CPU:** 250m request, 500m limit

### Services

- **Django:** LoadBalancer (localhost:80 → 8000)
- **PostgreSQL:** ClusterIP (internal only, port 5432)

## 🌐 Network Architecture

```
Internet/localhost
        │
        ├─ Port 80
        │
        ▼
┌───────────────────┐
│  LoadBalancer     │
│  Service          │
│  django-app-      │
│  service          │
└─────────┬─────────┘
          │
          ├─ Port 8000
          │
          ▼
┌───────────────────────────────┐
│  Django App Deployment        │
│  ┌────────┐    ┌────────┐    │
│  │Pod 1   │    │Pod 2   │    │
│  │django  │    │django  │    │
│  └────────┘    └────────┘    │
└───────────┬───────────────────┘
            │
            ├─ DATABASE_URL
            │  postgres://postgres-service:5432
            │
            ▼
┌───────────────────┐
│  ClusterIP        │
│  Service          │
│  postgres-service │
└─────────┬─────────┘
          │
          ├─ Port 5432
          │
          ▼
┌───────────────────┐
│  PostgreSQL       │
│  Deployment       │
│  ┌─────────────┐  │
│  │ Pod         │  │
│  │ postgres    │  │
│  │             │  │
│  │ ┌─────────┐ │  │
│  │ │ PVC     │ │  │
│  │ │ 1Gi     │ │  │
│  │ └─────────┘ │  │
│  └─────────────┘  │
└───────────────────┘
```

## 📁 File Structure

```
k8s/
├── STEP4_GUIDE.md              # Deployment guide
├── STEP4_COMPLETE.md           # This file (completion summary)
├── deployment.yaml             # Django Deployment ✅
├── service.yaml                # Django LoadBalancer Service ✅
├── configmap.yaml              # ConfigMap with settings ✅
├── secret.yaml                 # Secret with credentials ✅
├── postgres-pvc.yaml           # PostgreSQL storage
├── postgres-deployment.yaml    # PostgreSQL Deployment
└── postgres-service.yaml       # PostgreSQL ClusterIP Service
```

## 🎯 Step 4 Requirements Met

| Requirement          | Status | Details                                              |
| -------------------- | ------ | ---------------------------------------------------- |
| Deploy to Kubernetes | ✅     | Deployed to Docker Desktop Kubernetes cluster        |
| deployment.yaml      | ✅     | Django app with 2 replicas, health checks, resources |
| service.yaml         | ✅     | LoadBalancer exposing port 80 → 8000                 |
| configmap.yaml       | ✅     | Non-sensitive config: settings, database URL, hosts  |
| secret.yaml          | ✅     | Sensitive data: SECRET_KEY, database credentials     |
| Application Running  | ✅     | 2 Django pods running, API accessible                |
| Database Connected   | ✅     | PostgreSQL deployed, migrations completed            |
| External Access      | ✅     | http://localhost/api/ accessible and responding      |

## 🔧 Troubleshooting Reference

### Pod Issues

```powershell
# View pod status
kubectl get pods

# Describe pod for events
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name> --tail=100

# Follow logs
kubectl logs <pod-name> -f

# Check previous logs (if crashed)
kubectl logs <pod-name> --previous
```

### Service Issues

```powershell
# Check service
kubectl get svc django-app-service

# Check endpoints
kubectl get endpoints django-app-service

# Port forward as alternative
kubectl port-forward svc/django-app-service 8080:80
# Access at http://localhost:8080
```

### Database Issues

```powershell
# Check PostgreSQL pod
kubectl get pod -l app=postgres

# View PostgreSQL logs
kubectl logs -l app=postgres

# Test connection from Django
$POD = kubectl get pod -l app=django-app -o jsonpath="{.items[0].metadata.name}"
kubectl exec -it $POD -- python manage.py dbshell
```

## 🧹 Cleanup Commands

### Delete Everything

```powershell
kubectl delete -f k8s/
```

### Delete Individually

```powershell
kubectl delete deployment django-app
kubectl delete service django-app-service
kubectl delete configmap django-config
kubectl delete secret django-secrets
kubectl delete deployment postgres
kubectl delete service postgres-service
kubectl delete pvc postgres-pvc
```

## 📸 Screenshots Checklist

For submission, capture screenshots of:

1. ✅ **kubectl get all** - Shows all running resources
2. ✅ **kubectl get pods** - Shows 2 Django + 1 PostgreSQL pods running
3. ✅ **kubectl get svc** - Shows LoadBalancer service with localhost external IP
4. ✅ **curl http://localhost/api/** - Shows API response
5. ✅ **kubectl get configmap,secret** - Shows ConfigMap and Secret exist
6. ✅ **kubectl logs <django-pod>** - Shows application logs
7. ✅ **Manifest files** - deployment.yaml, service.yaml, configmap.yaml, secret.yaml

## 🎓 Key Learnings

1. **Kubernetes Deployments:** Managed pod replicas with declarative configuration
2. **Services:** Exposed applications using LoadBalancer for external access
3. **ConfigMaps:** Separated configuration from code
4. **Secrets:** Secured sensitive data with base64 encoding
5. **Persistent Volumes:** Maintained database state across pod restarts
6. **Health Checks:** Implemented liveness and readiness probes
7. **Resource Management:** Set CPU and memory limits
8. **Networking:** Connected multi-tier application (Django + PostgreSQL)

## ✅ Step 4: COMPLETE!

All requirements met:

- ✅ Kubernetes cluster (Docker Desktop)
- ✅ deployment.yaml created and deployed
- ✅ service.yaml created and deployed
- ✅ configmap.yaml created and deployed
- ✅ secret.yaml created and deployed
- ✅ Application running and accessible
- ✅ Database connected and working
- ✅ API tested and responding

**Application URL:** http://localhost/api/

**Next Steps:** Take screenshots and document for submission!
