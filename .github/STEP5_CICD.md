# Step 5: CI/CD Pipeline with GitHub Actions

## Overview

Fully automated multi-stage CI/CD pipeline that handles everything from code commit to production deployment.

## Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     CI/CD PIPELINE FLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Stage 1: Build & Test                                         │
│  ├─ Checkout code                                              │
│  ├─ Setup Python environment                                   │
│  ├─ Install dependencies                                       │
│  ├─ Run Django tests                                           │
│  ├─ Run pytest with coverage                                   │
│  └─ Upload coverage reports                                    │
│                                                                 │
│  Stage 2: Security & Linting                                   │
│  ├─ Black (code formatting)                                    │
│  ├─ isort (import sorting)                                     │
│  ├─ Flake8 (linting)                                           │
│  ├─ Bandit (security vulnerabilities)                          │
│  ├─ Safety (dependency vulnerabilities)                        │
│  └─ Trivy (filesystem scan)                                    │
│                                                                 │
│  Stage 3: Docker Build & Push                                  │
│  ├─ Setup Docker Buildx                                        │
│  ├─ Login to GitHub Container Registry                         │
│  ├─ Build Docker image with caching                            │
│  ├─ Push to registry with tags                                 │
│  └─ Scan image with Trivy                                      │
│                                                                 │
│  Stage 4: Terraform Apply                                      │
│  ├─ Configure AWS credentials                                  │
│  ├─ Terraform init                                             │
│  ├─ Terraform validate                                         │
│  ├─ Terraform plan                                             │
│  ├─ Terraform apply (on main branch)                           │
│  └─ Save outputs as artifacts                                  │
│                                                                 │
│  Stage 5: Deploy to Kubernetes                                 │
│  ├─ Setup kubectl                                              │
│  ├─ Configure cluster access                                   │
│  ├─ Create namespace                                           │
│  ├─ Apply Kubernetes manifests                                 │
│  ├─ Wait for rollout completion                                │
│  └─ Alternative: Run Ansible playbook                          │
│                                                                 │
│  Stage 6: Post-Deploy Smoke Tests                              │
│  ├─ Wait for service readiness                                 │
│  ├─ Test API health endpoints                                  │
│  ├─ Test database connectivity                                 │
│  ├─ Test Redis connectivity                                    │
│  ├─ Run integration tests                                      │
│  └─ Send deployment notifications                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Workflow Files

### 1. Main Pipeline: `ci-cd-pipeline.yml`

**Triggers:**

- Push to `main` or `develop` branches
- Pull requests to `main`
- Manual workflow dispatch

**Features:**

- All 6 stages in sequence
- Conditional execution based on branch
- Environment selection (dev/prod)
- Automatic rollback on failure

### 2. PR Validation: `pr-validation.yml`

**Triggers:**

- Pull requests to `main` or `develop`

**Features:**

- Fast validation checks
- Code formatting verification
- Linting
- Unit tests
- PR size warnings

### 3. Nightly Build: `nightly-build.yml`

**Triggers:**

- Daily at 2 AM UTC
- Manual trigger

**Features:**

- Multi-version Python testing (3.8-3.11)
- Comprehensive test suite
- Coverage reporting

### 4. Security Scan: `security-scan.yml`

**Triggers:**

- Weekly on Monday
- Push to `main`
- Manual trigger

**Features:**

- Snyk dependency scanning
- OWASP Dependency Check
- CodeQL analysis

## Stage Details

### Stage 1: Build & Test ✅

**Purpose:** Validate code quality and functionality

**Tools:**

- Python 3.9
- pytest with coverage
- Django test framework

**Actions:**

1. Install dependencies from requirements.txt
2. Run Django unit tests
3. Run pytest with coverage reporting
4. Upload coverage to CodeCov

**Success Criteria:**

- All tests pass
- Coverage uploaded successfully

---

### Stage 2: Security & Linting ✅

**Purpose:** Ensure code security and style compliance

**Tools:**

- **Black**: Code formatting
- **isort**: Import sorting
- **Flake8**: Style linting
- **Bandit**: Security issue detection
- **Safety**: Dependency vulnerability scanning
- **Trivy**: Comprehensive security scanning

**Actions:**

1. Check code formatting with Black
2. Validate import order with isort
3. Lint code with Flake8
4. Scan for security issues with Bandit
5. Check dependencies with Safety
6. Scan filesystem with Trivy
7. Upload results to GitHub Security

**Success Criteria:**

- No critical security issues
- Code style compliance (warnings allowed)

---

### Stage 3: Docker Build & Push ✅

**Purpose:** Create and publish container image

**Tools:**

- Docker Buildx
- GitHub Container Registry (GHCR)
- Docker metadata action

**Actions:**

1. Set up Docker Buildx for multi-platform builds
2. Login to GitHub Container Registry
3. Extract metadata for tags
4. Build Docker image with layer caching
5. Push to registry with multiple tags:
   - `latest` (on main branch)
   - `branch-name`
   - `sha-<commit>`
   - Semantic version tags
6. Scan built image with Trivy

**Success Criteria:**

- Image built successfully
- Pushed to registry with correct tags
- No critical vulnerabilities in image

---

### Stage 4: Terraform Apply ✅

**Purpose:** Provision cloud infrastructure

**Tools:**

- Terraform 1.6.0
- AWS provider
- Terraform Cloud (optional)

**Actions:**

1. Configure AWS credentials from secrets
2. Initialize Terraform backend
3. Validate Terraform configuration
4. Run `terraform plan`
5. Apply infrastructure changes (main branch only)
6. Save outputs as JSON artifact
7. Upload for next stages

**Success Criteria:**

- Infrastructure provisioned successfully
- No errors in apply
- Outputs available for deployment

**Note:** Only runs on `main` branch or manual dispatch

---

### Stage 5: Deploy to Kubernetes ✅

**Purpose:** Deploy application to Kubernetes cluster

**Tools:**

- kubectl
- Ansible (alternative)
- Kubernetes manifests

**Actions:**

1. Setup kubectl CLI
2. Configure cluster access from kubeconfig secret
3. Create namespace if doesn't exist
4. Apply manifests from `k8s/<environment>/`
5. Wait for rollout completion
6. Verify deployment status
7. (Alternative) Run Ansible playbook

**Success Criteria:**

- All pods running
- Deployment successful
- Services accessible

**Environment Selection:**

- Dev: `k8s/dev/`
- Prod: `k8s/prod/`

---

### Stage 6: Post-Deploy Smoke Tests ✅

**Purpose:** Verify deployment functionality

**Tests:**

1. **Service Health Check**
   - Test API endpoints
   - Verify HTTP 200 responses
2. **Database Connectivity**
   - Run Django database check
   - Verify migrations applied
3. **Redis Connectivity**
   - Test Redis ping command
   - Verify cache accessibility
4. **Integration Tests**

   - Run full test suite in deployed environment
   - Verify end-to-end functionality

5. **Notifications**
   - Send deployment status to Slack/Discord
   - Create GitHub deployment summary

**Success Criteria:**

- All health checks pass
- Database and Redis accessible
- Integration tests pass

---

## Required GitHub Secrets

### Essential Secrets

```yaml
AWS_ACCESS_KEY_ID          # AWS access key for Terraform
AWS_SECRET_ACCESS_KEY      # AWS secret key for Terraform
KUBE_CONFIG               # Base64-encoded kubeconfig file
GITHUB_TOKEN              # Automatically provided for GHCR
```

### Optional Secrets

```yaml
SNYK_TOKEN                # Snyk security scanning
CODECOV_TOKEN             # CodeCov coverage reporting
SLACK_WEBHOOK_URL         # Slack notifications
DISCORD_WEBHOOK_URL       # Discord notifications
```

**Setup Instructions:** See `.github/SECRETS.md`

---

## Usage

### Automatic Deployment (Push to main)

```bash
git add .
git commit -m "feat: add new feature"
git push origin main
```

Pipeline automatically runs all 6 stages.

### Manual Deployment (Workflow Dispatch)

1. Go to **Actions** tab in GitHub
2. Select **CI/CD Pipeline - Complete**
3. Click **Run workflow**
4. Select environment (dev/prod)
5. Click **Run workflow**

### Pull Request Validation

```bash
git checkout -b feature/new-feature
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature
```

Create PR → Pipeline runs build, test, and security checks.

---

## Pipeline Features

### ✅ Multi-Environment Support

- Dev environment (automatic on develop branch)
- Prod environment (automatic on main branch)
- Manual environment selection

### ✅ Caching

- Python dependencies cached
- Docker layers cached with BuildKit
- Terraform state remote backend

### ✅ Conditional Execution

- Terraform only on main branch
- Deployment only on main or manual trigger
- PR validation on pull requests

### ✅ Error Handling

- Continue-on-error for non-critical steps
- Automatic rollback on failure
- Detailed error reporting

### ✅ Artifacts

- Coverage reports
- Security scan results
- Terraform outputs
- Test results

---

## Monitoring & Notifications

### GitHub Actions Dashboard

- View all workflow runs
- Check stage status
- Download artifacts
- View logs

### Deployment Summary

Automatically added to workflow run:

- Environment
- Status
- Commit SHA
- Deployed services

### External Integrations

- **Slack**: Deployment notifications
- **Discord**: Status updates
- **CodeCov**: Coverage trends
- **Snyk**: Security vulnerabilities

---

## Rollback Procedure

### Automatic Rollback

Pipeline automatically rolls back on failure in smoke tests.

### Manual Rollback

**Option 1: GitHub Actions**

1. Go to Actions → CI/CD Pipeline
2. Trigger workflow manually
3. Pipeline will detect failure and rollback

**Option 2: kubectl**

```bash
kubectl rollout undo deployment/django-app -n <namespace>
```

**Option 3: Terraform**

```bash
cd terraform
terraform apply -target=module.previous_version
```

---

## Best Practices

### Branch Strategy

```
main (production)
  ├─ develop (staging)
  │   ├─ feature/xxx
  │   └─ bugfix/xxx
  └─ hotfix/xxx
```

### Commit Messages

Follow Conventional Commits:

```
feat: add new feature
fix: resolve bug
docs: update documentation
chore: update dependencies
test: add tests
```

### Pull Request Workflow

1. Create feature branch
2. Make changes
3. Push and create PR
4. Wait for CI checks
5. Request review
6. Merge to develop
7. Test in staging
8. Merge to main for production

---

## Troubleshooting

### Pipeline Fails at Build Stage

- Check Python dependencies
- Verify requirements.txt
- Review test failures

### Pipeline Fails at Security Stage

- Review Bandit/Safety reports
- Update vulnerable dependencies
- Fix security issues

### Docker Build Fails

- Check Dockerfile syntax
- Verify base image availability
- Check disk space

### Terraform Apply Fails

- Verify AWS credentials
- Check resource limits
- Review Terraform logs

### Deployment Fails

- Check kubeconfig secret
- Verify cluster connectivity
- Review Kubernetes events

### Smoke Tests Fail

- Check service endpoints
- Verify database/Redis connectivity
- Review application logs

---

## Optimization Tips

### Speed Up Pipeline

1. Use dependency caching
2. Parallelize independent jobs
3. Use Docker layer caching
4. Use self-hosted runners for faster builds

### Reduce Costs

1. Use GitHub-hosted runners (free for public repos)
2. Limit concurrent runs
3. Use conditional execution
4. Clean up old artifacts

### Improve Reliability

1. Add retry logic
2. Use health checks
3. Implement proper rollback
4. Monitor pipeline metrics

---

## Metrics & KPIs

### Pipeline Metrics

- **Build Time**: Target < 10 minutes
- **Success Rate**: Target > 95%
- **Deployment Frequency**: Multiple times per day
- **Mean Time to Recovery**: < 1 hour

### Quality Metrics

- **Code Coverage**: Target > 80%
- **Security Issues**: Target = 0 critical
- **Linting Score**: Target = 100%

---

## Future Enhancements

### Planned Features

- [ ] Blue-green deployments
- [ ] Canary releases
- [ ] Progressive rollout
- [ ] A/B testing support
- [ ] Performance testing stage
- [ ] Database migration checks
- [ ] Slack bot integration
- [ ] Auto-scaling based on metrics

---

## Summary

✅ **6-Stage Pipeline Complete:**

1. ✅ Build & Test - Unit tests, coverage
2. ✅ Security & Linting - Multiple tools
3. ✅ Docker Build & Push - GHCR with tags
4. ✅ Terraform Apply - Infrastructure as Code
5. ✅ Kubernetes Deploy - kubectl + Ansible
6. ✅ Smoke Tests - Health, DB, Redis, Integration

**Total Pipeline Time:** ~15-20 minutes
**Deployment Frequency:** On every push to main
**Rollback Time:** < 2 minutes

All stages are production-ready and follow industry best practices! 🚀
