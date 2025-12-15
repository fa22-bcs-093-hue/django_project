# Task 3 - Ansible Configuration Management

## Overview

This Ansible configuration automates the deployment of the Django DRF application to Kubernetes.

## Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── inventory/
│   └── hosts.yml           # Inventory file (localhost for K8s)
├── playbooks/
│   ├── main.yml            # Main orchestration playbook
│   ├── install_dependencies.yml  # Install K8s dependencies
│   ├── automate_docker.yml       # Build Docker images
│   └── deploy_kubernetes.yml     # Deploy to Kubernetes
└── README.md               # This file
```

## Prerequisites

1. Docker Desktop installed with Kubernetes enabled
2. Python 3.x installed
3. Ansible installed: `pip install ansible kubernetes openshift`

## Usage

### 1. Enable Kubernetes in Docker Desktop

- Open Docker Desktop → Settings → Kubernetes
- Check "Enable Kubernetes"
- Click "Apply & Restart"

### 2. Run Individual Playbooks

**Install dependencies:**

```bash
cd ansible
ansible-playbook playbooks/install_dependencies.yml
```

**Build Docker image:**

```bash
ansible-playbook playbooks/automate_docker.yml
```

**Deploy to Kubernetes:**

```bash
ansible-playbook playbooks/deploy_kubernetes.yml
```

### 3. Run Complete Pipeline

```bash
cd ansible
ansible-playbook playbooks/main.yml
```

## What Each Playbook Does

### install_dependencies.yml

- ✅ Checks if Docker is installed
- ✅ Verifies Kubernetes cluster is running
- ✅ Installs Python Kubernetes client
- ✅ Creates necessary directories

### automate_docker.yml

- ✅ Checks if Dockerfile exists
- ✅ Builds Docker image for Django app
- ✅ Tags image for Kubernetes
- ✅ Creates Docker network

### deploy_kubernetes.yml

- ✅ Creates Kubernetes namespace
- ✅ Creates ConfigMap for Django settings
- ✅ Creates Secret for sensitive data
- ✅ Deploys Django application (2 replicas)
- ✅ Creates LoadBalancer Service
- ✅ Waits for deployment to be ready

## Kubernetes Resources Created

1. **Namespace**: default
2. **ConfigMap**: django-config (environment variables)
3. **Secret**: django-secrets (passwords, keys)
4. **Deployment**: django-app (2 replicas)
5. **Service**: django-app-service (LoadBalancer)

## Verify Deployment

```bash
# Check pods
kubectl get pods

# Check services
kubectl get services

# Check deployments
kubectl get deployments

# Get service URL
kubectl get service django-app-service
```

## Access Application

After deployment, get the service URL:

```bash
kubectl get service django-app-service
```

Access at: `http://localhost` (if using LoadBalancer)

## Cleanup

To remove all resources:

```bash
kubectl delete deployment django-app
kubectl delete service django-app-service
kubectl delete configmap django-config
kubectl delete secret django-secrets
```

## Deliverables (Task 3)

- ✅ Ansible playbooks for automation
- ✅ Install dependencies on K8s nodes
- ✅ Deploy app configs and secrets
- ✅ Automate Docker and K8s deployment
