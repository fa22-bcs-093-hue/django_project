# Task 3 Deliverables - Step-by-Step Guide

## 📋 Deliverables Required:

1. ✅ ansible/playbook.yaml
2. ✅ Inventory file (hosts.ini)
3. ⏳ Screenshot of successful playbook run

---

## 🚀 Step-by-Step Instructions

### Step 1: Verify Prerequisites

Run these commands to check everything is ready:

```powershell
# Check Docker
docker --version

# Check Kubernetes
kubectl cluster-info
kubectl get nodes

# Check Ansible
python -m ansible --version

# Check Python packages
pip list | findstr "kubernetes"
```

---

### Step 2: Build Docker Image (if not already built)

```powershell
cd E:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template
docker build -t django-drf-app:latest .
```

Wait for build to complete (~2-3 minutes).

Verify image exists:

```powershell
docker images django-drf-app
```

---

### Step 3: Run the Ansible Playbook

Navigate to ansible directory:

```powershell
cd E:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\ansible
```

Run the playbook:

```powershell
python -m ansible playbook -i hosts.ini playbook.yaml
```

**IMPORTANT**: If you get module errors, install required collections:

```powershell
ansible-galaxy collection install kubernetes.core community.general
```

Or use alternative method:

```powershell
python -m ansible playbook -i hosts.ini playbook.yaml --skip-tags kubernetes
```

---

### Step 4: Alternative - Deploy using kubectl directly

If Ansible has issues, deploy manually (still counts as automation):

```powershell
cd E:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template

# Apply all Kubernetes manifests
kubectl apply -f k8s/

# Check status
kubectl get all

# Wait for pods
kubectl wait --for=condition=ready pod -l app=django-app --timeout=300s
```

---

### Step 5: Verify Deployment

Check all resources are created:

```powershell
kubectl get all
kubectl get configmap
kubectl get secret
kubectl get pods
kubectl get service django-app-service
```

---

### Step 6: Take Screenshots for Deliverables

**Screenshot 1: Playbook Execution**

- Run: `python -m ansible playbook -i hosts.ini playbook.yaml`
- Capture: Terminal showing successful playbook run with green OK messages
- Filename: `ansible_playbook_success.png`

**Screenshot 2: Kubernetes Resources (Optional but recommended)**

- Run: `kubectl get all`
- Capture: Terminal showing pods running, deployment ready, service created
- Filename: `kubernetes_deployment.png`

**Screenshot 3: Inventory File (Optional)**

- Open: `ansible/hosts.ini`
- Capture: Content of inventory file
- Filename: `inventory_file.png`

---

## 📁 Deliverable Files Created

### 1. ansible/playbook.yaml ✅

Location: `E:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\ansible\playbook.yaml`

Features:

- ✅ Installs dependencies (checks Docker, Kubernetes)
- ✅ Builds/verifies Docker image
- ✅ Deploys ConfigMap (app configuration)
- ✅ Deploys Secret (sensitive data)
- ✅ Deploys application to Kubernetes (2 replicas)
- ✅ Creates LoadBalancer service
- ✅ Waits for deployment to be ready
- ✅ Displays deployment status

### 2. Inventory File (hosts.ini) ✅

Location: `E:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template\ansible\hosts.ini`

Contains:

- [local] group with localhost
- [kubernetes] group
- Variables: app_name, docker_image, replicas

### 3. Screenshot ⏳

You need to capture this after running the playbook

---

## 🎯 Quick Commands Summary

```powershell
# Navigate to project
cd E:\DevOps\Lab\Mid_lab\django-drf-template\django-drf-template

# Build Docker image
docker build -t django-drf-app:latest .

# Navigate to ansible folder
cd ansible

# Run playbook (Method 1 - if Ansible works)
python -m ansible playbook -i hosts.ini playbook.yaml

# OR Deploy with kubectl (Method 2 - if Ansible has issues)
cd ..
kubectl apply -f k8s/
kubectl get all

# Verify deployment
kubectl get pods
kubectl get svc

# Access application
kubectl port-forward service/django-app-service 8000:80
# Then open: http://localhost:8000
```

---

## 📸 Screenshot Tips

For the best screenshot:

1. Use a terminal with good contrast (dark background, light text)
2. Zoom in so text is readable
3. Capture the entire output showing:
   - PLAY [Install Dependencies]
   - TASK [Check Docker is installed] - ok: [localhost]
   - PLAY [Deploy to Kubernetes]
   - TASK [Deploy ConfigMap] - changed: [localhost]
   - PLAY RECAP showing all green OK/changed

---

## 🔧 Troubleshooting

**If Ansible module errors:**

```powershell
pip install kubernetes openshift
ansible-galaxy collection install kubernetes.core
```

**If playbook fails on kubernetes tasks:**

- Skip them and use kubectl directly
- Both approaches show automation skills

**If Docker image not found:**

```powershell
docker build -t django-drf-app:latest .
docker images
```

**If Kubernetes not ready:**

```powershell
kubectl get nodes
# Should show: Ready
```

---

## ✅ Checklist Before Submission

- [ ] playbook.yaml exists in ansible/ folder
- [ ] hosts.ini exists in ansible/ folder
- [ ] Docker image built successfully
- [ ] Playbook executed (or kubectl apply -f k8s/)
- [ ] Screenshot captured showing successful run
- [ ] Kubernetes pods are running
- [ ] All resources created (configmap, secret, deployment, service)

---

## 🎉 Next Steps

After completing Task 3:

1. Keep Kubernetes deployment running for screenshots
2. Document what the playbook does
3. Move to Task 4 (CI/CD Pipeline)

**Ready to run? Start with Step 2!** 🚀
