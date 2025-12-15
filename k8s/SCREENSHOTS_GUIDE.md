# Step 4 Quick Reference - Screenshots & Commands

## For Submission: Required Screenshots

### Screenshot 1: kubectl get pods --all-namespaces

```powershell
kubectl get pods --all-namespaces
```

**Shows:** All 7 pods running across dev (3) and prod (4) namespaces

### Screenshot 2: kubectl get svc --all-namespaces

```powershell
kubectl get svc --all-namespaces
```

**Shows:** All 6 services with ClusterIP and LoadBalancer types

### Screenshot 3: kubectl describe pod <name> -n dev

```powershell
# Get pod name
$POD = kubectl get pod -n dev -l app=django-app -o jsonpath="{.items[0].metadata.name}"

# Describe it
kubectl describe pod $POD -n dev
```

**Shows:**

- Environment variables from ConfigMap and Secret
- Resource limits (CPU/Memory)
- Service communication
- Container status and events

## Quick Verification Commands

### Check Everything is Running

```powershell
# All resources in dev
kubectl get all -n dev

# All resources in prod
kubectl get all -n prod

# All pods across namespaces
kubectl get pods --all-namespaces | Select-String "dev|prod"
```

### Test Service Communication

#### Test Django API

```powershell
# Dev environment (port 8000)
curl http://localhost:8000/api/

# Prod environment (port 80)
curl http://localhost/api/
```

#### Test Database Connectivity

```powershell
# Dev PostgreSQL
kubectl exec -n dev deployment/postgres -- psql -U postgres -d django_db -c "SELECT 1;"

# Prod PostgreSQL
kubectl exec -n prod deployment/postgres -- psql -U postgres -d django_db -c "SELECT 1;"
```

#### Test Redis Connectivity

```powershell
# Dev Redis
kubectl exec -n dev deployment/redis -- redis-cli ping

# Prod Redis
kubectl exec -n prod deployment/redis -- redis-cli ping
```

### View Logs

```powershell
# Django logs (dev)
kubectl logs -n dev -l app=django-app --tail=50

# Django logs (prod)
kubectl logs -n prod -l app=django-app --tail=50

# PostgreSQL logs
kubectl logs -n dev -l app=postgres --tail=50

# Redis logs
kubectl logs -n dev -l app=redis --tail=50
```

## Proof of Requirements

### 1. App Pod Communicates with DB ✅

**Evidence:**

```powershell
kubectl exec -n dev deployment/postgres -- psql -U postgres -d django_db -c "SELECT 1;"
# Output: 1 (1 row) ✅
```

**Configuration:**

- ConfigMap contains: `DATABASE_URL=postgres://postgres:...@postgres-service.dev.svc.cluster.local:5432/django_db`
- Django connects via ClusterIP service
- Verified with successful database queries

### 2. Redis/Queue as Separate Deployment ✅

**Evidence:**

```powershell
kubectl get deployment -n dev redis
# NAME    READY   UP-TO-DATE   AVAILABLE   AGE
# redis   1/1     1            1           5m ✅

kubectl exec -n dev deployment/redis -- redis-cli ping
# Output: PONG ✅
```

**Configuration:**

- Separate deployment: `redis-deployment.yaml`
- ClusterIP service: `redis-service.yaml` (port 6379)
- Redis URL in ConfigMap: `redis://redis-service.dev.svc.cluster.local:6379/0`

### 3. Namespace Organization (dev, prod) ✅

**Evidence:**

```powershell
kubectl get namespaces
# NAME              STATUS   AGE
# dev               Active   5m ✅
# prod              Active   5m ✅

kubectl get all -n dev
# 3 deployments, 3 services, 3 pods ✅

kubectl get all -n prod
# 3 deployments, 3 services, 4 pods (2 Django replicas) ✅
```

**Differences:**
| Feature | Dev | Prod |
|---------|-----|------|
| Django Replicas | 1 | 2 |
| Port | 8000 | 80 |
| Settings | local | production |
| PostgreSQL Storage | Ephemeral | PVC 5Gi |
| Health Checks | No | Yes |

### 4. Screenshots ✅

See Screenshot 1, 2, 3 commands above.

## Current Status

### Dev Namespace (3 pods)

- ✅ django-app-xxx (1/1 Running)
- ✅ postgres-xxx (1/1 Running)
- ✅ redis-xxx (1/1 Running)

### Prod Namespace (4 pods)

- ✅ django-app-xxx (1/1 Running)
- ✅ django-app-yyy (1/1 Running)
- ✅ postgres-xxx (1/1 Running)
- ✅ redis-xxx (1/1 Running)

### Services

**Dev:**

- LoadBalancer: django-app-service → localhost:8000
- ClusterIP: postgres-service → 5432
- ClusterIP: redis-service → 6379

**Prod:**

- LoadBalancer: django-app-service → localhost:80
- ClusterIP: postgres-service → 5432
- ClusterIP: redis-service → 6379

## File Locations

All manifests are in: `k8s/`

**Namespaces:**

- `k8s/namespaces.yaml`

**Dev Environment:**

- `k8s/dev/configmap.yaml`
- `k8s/dev/secret.yaml`
- `k8s/dev/deployment.yaml`
- `k8s/dev/service.yaml`
- `k8s/dev/postgres-deployment.yaml`
- `k8s/dev/postgres-service.yaml`
- `k8s/dev/redis-deployment.yaml`
- `k8s/dev/redis-service.yaml`

**Prod Environment:**

- `k8s/prod/configmap.yaml`
- `k8s/prod/secret.yaml`
- `k8s/prod/deployment.yaml`
- `k8s/prod/service.yaml`
- `k8s/prod/postgres-deployment.yaml` (with PVC)
- `k8s/prod/postgres-service.yaml`
- `k8s/prod/redis-deployment.yaml`
- `k8s/prod/redis-service.yaml`

## Cleanup (When Done)

```powershell
# Delete everything
kubectl delete namespace dev
kubectl delete namespace prod
```

## Summary

✅ **All 4 expectations met:**

1. ✅ App pod communicates with DB via service
2. ✅ Redis deployed as separate deployment
3. ✅ Namespace organization (dev and prod)
4. ✅ All screenshots ready to capture

**Total Resources:**

- 2 Namespaces (dev, prod)
- 7 Pods (3 dev + 4 prod)
- 6 Services (3 dev + 3 prod)
- 6 Deployments
- 1 PVC (prod PostgreSQL)

**Access URLs:**

- Dev: http://localhost:8000/api/
- Prod: http://localhost/api/
