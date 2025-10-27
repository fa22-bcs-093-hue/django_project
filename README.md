# Django DRF Template

A production-ready Django REST Framework (DRF) template that demonstrates:

- Containerization with **Docker**
- Continuous Integration and Deployment (CI/CD) with **GitHub Actions**
- Automated **testing configuration** using Django’s built-in test runner

---

## Features

- Django 4+ and Django REST Framework
- PostgreSQL support (via `libpq-dev`)
- Dockerfile for consistent environment setup
- GitHub Actions workflow for:
  - Installing dependencies
  - Running tests
  - Building and pushing Docker images automatically
- Clean and extensible project structure

---

## Prerequisites

Before you begin, make sure you have the following installed locally:

- **Python 3.9+**
- **Docker & Docker Compose**
- **Git**
- A **DockerHub account** (for image pushing)

---

## Project Structure

django-drf-template/
│
├── .github/
│ └── workflows/
│ └── ci.yml # GitHub Actions CI/CD pipeline
│
├── django_project/
│ └── config/
│ └── settings/
│ └── test.py # Django test settings file
│
├── Dockerfile # Docker image definition
├── entrypoint-simple.sh # Entrypoint script for container startup
├── requirements.txt # Python dependencies
├── manage.py # Django management script
└── README.md
