# 🚀 Deployment Setup Guide

This guide will help you set up cloud deployment for your Django DRF application.

## 📋 Prerequisites

1. **GitHub Repository** (already done ✅)
2. **Docker Hub Account** (for container registry)
3. **Render Account** (optional, for cloud deployment)
4. **Railway Account** (optional, for cloud deployment)

## 🔐 Step 1: Set Up GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

### Required Secrets:

#### Docker Hub Secrets:
- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Your Docker Hub access token

#### Render Secrets (Optional):
- `RENDER_SERVICE_ID` - Your Render service ID
- `RENDER_API_KEY` - Your Render API key

#### Railway Secrets (Optional):
- `RAILWAY_TOKEN` - Your Railway token
- `RAILWAY_PROJECT_ID` - Your Railway project ID
- `RAILWAY_SERVICE_NAME` - Your Railway service name (default: 'web')

## 🐳 Step 2: Docker Hub Setup

1. **Create Docker Hub Account**:
   - Go to [hub.docker.com](https://hub.docker.com)
   - Sign up for a free account

2. **Create Access Token**:
   - Go to Account Settings → Security
   - Click "New Access Token"
   - Name: "GitHub Actions"
   - Permissions: Read, Write, Delete
   - Copy the token

3. **Add to GitHub Secrets**:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: The access token you created

## ☁️ Step 3: Render Setup (Optional)

1. **Create Render Account**:
   - Go to [render.com](https://render.com)
   - Sign up with GitHub

2. **Create New Web Service**:
   - Connect your GitHub repository
   - Choose "Docker" as the environment
   - Set Dockerfile path: `./DockerFile`
   - Set Docker context: `.`

3. **Get Service ID and API Key**:
   - Service ID: Found in your service URL
   - API Key: Account Settings → API Keys

4. **Add to GitHub Secrets**:
   - `RENDER_SERVICE_ID`: Your service ID
   - `RENDER_API_KEY`: Your API key

## 🚂 Step 4: Railway Setup (Optional)

1. **Create Railway Account**:
   - Go to [railway.app](https://railway.app)
   - Sign up with GitHub

2. **Create New Project**:
   - Connect your GitHub repository
   - Choose "Deploy from GitHub repo"

3. **Get Railway Token**:
   - Go to Account Settings → Tokens
   - Create new token
   - Copy the token

4. **Add to GitHub Secrets**:
   - `RAILWAY_TOKEN`: Your Railway token
   - `RAILWAY_PROJECT_ID`: Your project ID
   - `RAILWAY_SERVICE_NAME`: Your service name (optional)

## 🎯 Step 5: Test the Pipeline

1. **Push to main branch**:
   ```bash
   git add .
   git commit -m "Add CI/CD pipeline and deployment config"
   git push origin main
   ```

2. **Check GitHub Actions**:
   - Go to your repository → Actions tab
   - Watch the pipeline run
   - Check the logs for each stage

## 📊 What the Pipeline Does

### Stage 1: Build & Install
- Sets up Python 3.9
- Installs dependencies
- Caches for faster builds

### Stage 2: Lint/Security Scan
- Code formatting (Black)
- Import sorting (isort)
- Linting (flake8)
- Security scan (bandit)
- Vulnerability check (safety)

### Stage 3: Test with Database
- Sets up PostgreSQL service
- Runs database migrations
- Executes tests with coverage
- Generates test reports

### Stage 4: Build Docker Image
- Builds Docker image
- Pushes to GitHub Container Registry
- Pushes to Docker Hub
- Uses build caching

### Stage 5: Deploy (Main Branch Only)
- Deploys to Render (if configured)
- Deploys to Railway (if configured)
- Shows deployment logs
- Runs health checks

## 🔍 Monitoring Deployments

### GitHub Actions Logs:
- Go to Actions tab in your repository
- Click on any workflow run
- View detailed logs for each stage

### Docker Hub:
- Check your Docker Hub repository
- Images will be tagged with branch names and commit SHAs

### Render/Railway:
- Check your service dashboard
- View deployment logs
- Monitor application health

## 🛠️ Troubleshooting

### Common Issues:

1. **Docker Hub Authentication Failed**:
   - Check if `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are set correctly
   - Verify the token has proper permissions

2. **Render Deployment Failed**:
   - Check if `RENDER_SERVICE_ID` and `RENDER_API_KEY` are set
   - Verify the service ID is correct

3. **Railway Deployment Failed**:
   - Check if `RAILWAY_TOKEN` and `RAILWAY_PROJECT_ID` are set
   - Verify the token is valid

4. **Tests Failing**:
   - Check the test logs in GitHub Actions
   - Ensure all dependencies are installed correctly

## 📈 Next Steps

1. **Monitor Performance**: Set up monitoring and alerting
2. **Add Notifications**: Configure Slack/Discord notifications
3. **Environment Variables**: Set up production environment variables
4. **Database**: Set up production database
5. **Domain**: Configure custom domain
6. **SSL**: Set up SSL certificates

## 🎉 Success!

Your Django DRF application now has:
- ✅ Automated CI/CD pipeline
- ✅ Docker image building and pushing
- ✅ Cloud deployment capabilities
- ✅ Comprehensive testing
- ✅ Security scanning
- ✅ Deployment logging

The pipeline will automatically run on every push to main branch and deploy your application!
