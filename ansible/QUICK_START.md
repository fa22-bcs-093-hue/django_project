# Task 3 - Ansible Quick Start Guide

## ⚠️ BEFORE YOU START

### Enable Kubernetes in Docker Desktop:

1. Open Docker Desktop
2. Click Settings (gear icon)
3. Go to "Kubernetes" tab
4. Check ✅ "Enable Kubernetes"
5. Click "Apply & Restart"
6. Wait 2-3 minutes for K8s to start

### Verify Kubernetes is Running:

```powershell
kubectl cluster-info
kubectl get nodes
```

You should see: `Kubernetes control plane is running at...`

---

## 🚀 Run Task 3 - Ansible Automation

### Option 1: Run Complete Pipeline (Recommended)

```powershell
cd ansible
ansible-playbook playbooks/main.yml
```

This will:

1. ✅ Install dependencies
2. ✅ Build Docker image
3. ✅ Deploy to Kubernetes

### Option 2: Run Step-by-Step

**Step 1: Install Dependencies**

```powershell
cd ansible
ansible-playbook playbooks/install_dependencies.yml
```

**Step 2: Build Docker Image**

```powershell
ansible-playbook playbooks/automate_docker.yml
```

**Step 3: Deploy to Kubernetes**

```powershell
ansible-playbook playbooks/deploy_kubernetes.yml
```

---

## ✅ Verify Deployment

### Check Kubernetes Resources:

```powershell
# Check all resources
kubectl get all

# Check pods
kubectl get pods

# Check services
kubectl get svc

# Check deployments
kubectl get deployments

# Get detailed pod info
kubectl describe pod <pod-name>
```

### Access the Application:

```powershell
# Get service URL
kubectl get service django-app-service

# Forward port to access locally
kubectl port-forward service/django-app-service 8000:80
```

Then open: http://localhost:8000

---

## 📸 Screenshots for Task 3 Deliverables

Take these screenshots:

1. **Ansible playbook execution output** - Terminal showing successful run
2. **Kubernetes pods running** - `kubectl get pods`
3. **Kubernetes services** - `kubectl get services`
4. **Application accessible** - Browser showing app running
5. **ConfigMap and Secrets** - `kubectl get configmap,secret`

---

## 🧹 Cleanup

To remove all Kubernetes resources:

```powershell
kubectl delete deployment django-app
kubectl delete service django-app-service
kubectl delete configmap django-config
kubectl delete secret django-secrets
```

---

## 📋 Task 3 Deliverables Checklist

- [ ] Ansible playbooks created
- [ ] Dependencies installed on K8s nodes
- [ ] Docker image built automatically
- [ ] Application deployed to Kubernetes
- [ ] ConfigMaps and Secrets created
- [ ] Services exposed
- [ ] Screenshots taken
- [ ] Documentation complete

---

## 🔧 Troubleshooting

**If Kubernetes won't start:**

- Restart Docker Desktop
- Check system resources (RAM, CPU)
- Try: Settings → Reset Kubernetes Cluster

**If playbook fails:**

```powershell
# Check Ansible version
ansible --version

# Run with verbose mode
ansible-playbook playbooks/main.yml -vvv

# Check Python packages
pip list | findstr "ansible kubernetes"
```

**If pods won't start:**

```powershell
# Check pod status
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Check events
kubectl get events --sort-by='.lastTimestamp'
```

---

## ⏭️ Next Steps

Once Task 3 is complete, move to:

- **Task 4**: CI/CD Pipeline (GitHub Actions)
- **Task 5**: Monitoring & Logging

**First: Enable Kubernetes, then run the playbooks!** 🚀
