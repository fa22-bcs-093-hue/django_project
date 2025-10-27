# Docker Setup for Django DRF Application

This document describes the Docker containerization setup for the Django REST Framework application.

## Services

### 1. PostgreSQL Database (`web_app_db`)
- **Image**: postgres:13
- **Port**: 5432 (exposed to host)
- **Persistent Storage**: `postgres_data` volume
- **Health Check**: Built-in PostgreSQL health check
- **Network**: `django_network`

### 2. Django Backend (`django_backend`)
- **Build**: Custom Dockerfile
- **Port**: 8000 (exposed to host)
- **Volumes**: 
  - Source code mount for development
  - `static_volume` for static files
  - `media_volume` for media files
- **Dependencies**: Waits for database to be healthy
- **Network**: `django_network`

### 3. Frontend (`frontend`) - Optional
- **Build**: Custom Dockerfile.frontend
- **Port**: 3000 (exposed to host)
- **Profile**: `frontend` (disabled by default)
- **Network**: `django_network`

## Networking

All services communicate through Docker's internal network (`django_network`) using service names as hostnames:
- Database: `web_app_db:5432`
- Backend: `django_backend:8000`
- Frontend: `frontend:3000`

## Persistent Storage

### Database Volume
- **Volume**: `postgres_data`
- **Mount Point**: `/var/lib/postgresql/data`
- **Purpose**: Persistent database storage

### Application Volumes
- **static_volume**: Static files (CSS, JS, images)
- **media_volume**: User-uploaded media files

## Environment Variables

The following environment variables are configured in docker-compose.yml:

```yaml
# Django Settings
SECRET_KEY=your-secret-key-here-change-in-production
DEBUG=True
DJANGO_PORT=8000

# Database Settings
POSTGRES_USER=django_user
POSTGRES_NAME=django_db
POSTGRES_PASSWORD=django_password
POSTGRES_HOST=web_app_db
POSTGRES_PORT=5432
```

## Usage

### Start Services
```bash
# Start all services
docker-compose up -d

# Start with frontend
docker-compose --profile frontend up -d

# Start in foreground (for debugging)
docker-compose up
```

### Stop Services
```bash
# Stop services
docker-compose down

# Stop and remove volumes (WARNING: This will delete database data)
docker-compose down -v
```

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs django_backend
docker-compose logs web_app_db
```

### Access Services
- **Django Backend**: http://localhost:8000
- **PostgreSQL**: localhost:5432
- **Frontend** (if enabled): http://localhost:3000

### Database Access
```bash
# Connect to database
docker-compose exec web_app_db psql -U django_user -d django_db

# Or from host
psql -h localhost -p 5432 -U django_user -d django_db
```

### Django Management Commands
```bash
# Run Django commands
docker-compose exec django_backend python manage.py migrate
docker-compose exec django_backend python manage.py createsuperuser
docker-compose exec django_backend python manage.py collectstatic
```

## Development

### Hot Reload
The Django service is configured with volume mounting for development, so code changes are reflected immediately without rebuilding the container.

### Database Migrations
Migrations are automatically run when the container starts via the entrypoint script.

### Static Files
Static files are collected to the `static_volume` and can be served by a reverse proxy in production.

## Production Considerations

1. **Security**: Change default passwords and secret keys
2. **Environment Variables**: Use proper environment variable management
3. **Reverse Proxy**: Add nginx or similar for production
4. **SSL**: Configure SSL certificates
5. **Monitoring**: Add logging and monitoring solutions
6. **Backup**: Implement database backup strategies

## Troubleshooting

### Container Won't Start
```bash
# Check logs
docker-compose logs django_backend

# Check container status
docker-compose ps
```

### Database Connection Issues
```bash
# Check database logs
docker-compose logs web_app_db

# Test database connectivity
docker-compose exec django_backend python manage.py dbshell
```

### Permission Issues
```bash
# Fix file permissions
docker-compose exec django_backend chown -R django:django /django_project
```
