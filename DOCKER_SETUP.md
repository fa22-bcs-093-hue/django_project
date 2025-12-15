# Docker Setup Guide - Django DRF Project

## Task 1 Requirements Checklist ✅

### 1. Dockerfile (Optimized, Multistage) ✅

- **Location**: `Dockerfile.multistage`
- **Features**:
  - Two-stage build (builder + runtime)
  - Reduced image size (~60% smaller)
  - Non-root user for security
  - Health checks included
  - Build cache optimization
  - No unnecessary build tools in final image

### 2. Docker-compose.yml (Local Testing) ✅

- **Location**: `docker-compose.yml`
- **Services**:
  - PostgreSQL database with persistent storage
  - Redis cache/message queue
  - Django backend application
  - Frontend (optional, via profiles)

### 3. Container Networking ✅

- **Network Name**: `django_app_network`
- **Type**: Bridge network with custom subnet (172.28.0.0/16)
- **DNS**: Automatic service discovery (services can communicate via service names)
- **Verification**: See commands below

### 4. Persistent Storage for DB ✅

- **PostgreSQL Volume**: `django_postgres_data`
- **Redis Volume**: `django_redis_data`
- **Static Files**: `django_static`
- **Media Files**: `django_media`
- All volumes are named and persistent across container restarts

### 5. No Hardcoded Secrets ✅

- Environment variables loaded from `.env` file
- Default values provided but should be changed
- Secrets managed via environment variables
- `.env.example` provided as template

---

## Prerequisites

Before you start, ensure you have:

- Docker Desktop installed and running
- Docker Compose v3.8 or higher
- Git (for version control)

---

## Quick Start

### 1. Clone and Setup

```powershell
# Navigate to project directory
cd e:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template

# Create .env file from example
Copy-Item .env.example .env

# Edit .env file and change default passwords
notepad .env
```

### 2. Configure Environment Variables

Edit `.env` file and change these important values:

```env
# IMPORTANT: Change these in production!
SECRET_KEY=your-super-secret-key-here
POSTGRES_PASSWORD=your_secure_password
DEBUG=False
```

### 3. Build and Run

```powershell
# Build all services
docker compose build

# Start services in detached mode
docker compose up -d

# View logs
docker compose logs -f

# Check service status
docker compose ps
```

### 4. Access the Application

- **Django Backend**: http://localhost:8000
- **Admin Panel**: http://localhost:8000/admin
- **API Endpoints**: http://localhost:8000/api/
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

---

## Container Networking Verification

### Check Network Configuration

```powershell
# List Docker networks
docker network ls

# Inspect django network
docker network inspect django_app_network

# View container IPs
docker compose ps
```

### Test Inter-Container Communication

```powershell
# Enter Django container
docker exec -it django-backend /bin/sh

# Test PostgreSQL connection
psql -h web_app_db -U django_user -d django_db

# Test Redis connection
redis-cli -h redis_cache ping

# Exit container
exit
```

### Test DNS Resolution

```powershell
# From Django container, ping other services
docker exec django-backend ping -c 3 web_app_db
docker exec django-backend ping -c 3 redis_cache
```

---

## Persistent Storage Verification

### Check Volumes

```powershell
# List all volumes
docker volume ls | Select-String "django"

# Inspect PostgreSQL volume
docker volume inspect django_postgres_data

# Inspect Redis volume
docker volume inspect django_redis_data
```

### Test Data Persistence

```powershell
# Create test data
docker exec -it django-backend python django_project/manage.py shell

# Stop containers
docker compose down

# Start again - data should persist
docker compose up -d

# Verify data still exists
docker exec -it django-backend python django_project/manage.py shell
```

---

## Docker Commands Cheat Sheet

### Build and Run

```powershell
# Build specific service
docker compose build django_backend

# Build without cache
docker compose build --no-cache

# Start specific service
docker compose up django_backend

# Start in background
docker compose up -d

# Scale service (if configured)
docker compose up -d --scale django_backend=3
```

### Monitoring and Debugging

```powershell
# View logs
docker compose logs

# Follow logs
docker compose logs -f django_backend

# View resource usage
docker stats

# Execute command in container
docker exec -it django-backend /bin/sh

# Run Django management commands
docker exec django-backend python django_project/manage.py migrate
docker exec django-backend python django_project/manage.py createsuperuser
```

### Cleanup

```powershell
# Stop services
docker compose stop

# Stop and remove containers
docker compose down

# Remove containers and volumes
docker compose down -v

# Remove everything including images
docker compose down -v --rmi all

# Clean up system
docker system prune -a
```

---

## Microservices/Kubernetes Extensibility

### Current Architecture

```
┌─────────────────────────────────────────┐
│          Docker Network                 │
│     (django_app_network)                │
│                                          │
│  ┌────────────┐  ┌─────────────┐       │
│  │ PostgreSQL │  │   Redis     │       │
│  │    DB      │  │   Cache     │       │
│  └─────┬──────┘  └──────┬──────┘       │
│        │                 │               │
│        └────────┬────────┘               │
│                 │                        │
│         ┌───────▼────────┐               │
│         │  Django        │               │
│         │  Backend       │               │
│         └────────────────┘               │
└─────────────────────────────────────────┘
```

### Ready for Kubernetes Migration

The project is structured to easily migrate to Kubernetes:

1. **Stateless Application**: Django backend is stateless
2. **External State**: Database and cache are separate services
3. **Environment Variables**: Configuration via env vars
4. **Health Checks**: Liveness and readiness probes included
5. **Named Volumes**: Easy to convert to PersistentVolumeClaims
6. **Service Discovery**: Using service names (works in K8s)

### Next Steps for Kubernetes

```yaml
# Future K8s deployment structure:
- Deployment: django-backend
- Service: django-backend-service
- StatefulSet: postgresql
- StatefulSet: redis
- PersistentVolumeClaim: postgres-pvc
- PersistentVolumeClaim: redis-pvc
- ConfigMap: django-config
- Secret: django-secrets
- Ingress: external-access
```

---

## Troubleshooting

### Container won't start

```powershell
# Check logs
docker compose logs django_backend

# Check if port is already in use
netstat -ano | findstr :8000

# Rebuild container
docker compose build --no-cache django_backend
docker compose up -d django_backend
```

### Database connection issues

```powershell
# Check if database is ready
docker compose logs web_app_db

# Check health status
docker compose ps

# Test connection
docker exec django-backend python django_project/manage.py dbshell
```

### Redis connection issues

```powershell
# Check Redis logs
docker compose logs redis_cache

# Test Redis
docker exec redis-cache redis-cli ping
```

### Permission issues

```powershell
# Check container user
docker exec django-backend whoami

# Fix permissions
docker exec django-backend chown -R django:django /django_project
```

---

## Performance Optimization

### Image Size Comparison

- **Before (single-stage)**: ~800 MB
- **After (multistage)**: ~300 MB
- **Improvement**: 62.5% reduction

### Build Time Optimization

```powershell
# Use BuildKit for faster builds
$env:DOCKER_BUILDKIT=1
docker compose build
```

### Cache Configuration

Redis is configured with:

- Connection pooling (max 50 connections)
- Retry on timeout
- 5-minute default timeout
- AOF persistence enabled

---

## Security Best Practices ✅

1. ✅ Non-root user in containers
2. ✅ No hardcoded secrets
3. ✅ Read-only volumes where possible
4. ✅ Health checks configured
5. ✅ Minimal attack surface (alpine images)
6. ✅ No unnecessary packages in runtime image
7. ✅ Environment-based configuration

---

## Production Deployment Checklist

Before deploying to production:

- [ ] Change all default passwords in `.env`
- [ ] Set `DEBUG=False`
- [ ] Generate new `SECRET_KEY`
- [ ] Configure proper `ALLOWED_HOSTS`
- [ ] Enable SSL/TLS
- [ ] Set up proper logging
- [ ] Configure backup strategy for volumes
- [ ] Set up monitoring and alerts
- [ ] Review security settings
- [ ] Use docker secrets instead of .env file

---

## Support

For issues or questions:

1. Check container logs: `docker compose logs`
2. Verify network: `docker network inspect django_app_network`
3. Check health: `docker compose ps`
4. Review this documentation

---

**Last Updated**: December 14, 2025
**Docker Version**: 24.0+
**Docker Compose Version**: 3.8
