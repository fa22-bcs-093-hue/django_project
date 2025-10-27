# Makefile for Django Docker project

.PHONY: help build up down logs shell migrate superuser test clean

# Default target
help:
	@echo "Available commands:"
	@echo "  build      - Build Docker images"
	@echo "  up         - Start all services"
	@echo "  down       - Stop all services"
	@echo "  logs       - Show logs for all services"
	@echo "  shell      - Open shell in Django container"
	@echo "  migrate    - Run database migrations"
	@echo "  superuser  - Create Django superuser"
	@echo "  test       - Run Django tests"
	@echo "  clean      - Clean up containers and volumes"

# Build images
build:
	docker-compose build

# Start services
up:
	docker-compose up -d

# Start with frontend
up-frontend:
	docker-compose --profile frontend up -d

# Stop services
down:
	docker-compose down

# Stop and remove volumes
down-volumes:
	docker-compose down -v

# Show logs
logs:
	docker-compose logs -f

# Django logs only
logs-django:
	docker-compose logs -f django_backend

# Database logs only
logs-db:
	docker-compose logs -f web_app_db

# Open shell in Django container
shell:
	docker-compose exec django_backend /bin/bash

# Run migrations
migrate:
	docker-compose exec django_backend python manage.py migrate

# Create superuser
superuser:
	docker-compose exec django_backend python manage.py createsuperuser

# Run tests
test:
	docker-compose exec django_backend python manage.py test

# Collect static files
collectstatic:
	docker-compose exec django_backend python manage.py collectstatic --noinput

# Database shell
dbshell:
	docker-compose exec django_backend python manage.py dbshell

# Clean up
clean:
	docker-compose down -v
	docker system prune -f

# Restart services
restart:
	docker-compose restart

# Show status
status:
	docker-compose ps
