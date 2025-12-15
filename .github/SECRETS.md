# Required GitHub Secrets

## AWS Credentials (for Terraform)

```
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
```

## Kubernetes Configuration

```
KUBE_CONFIG=base64_encoded_kubeconfig
```

To generate:

```bash
cat ~/.kube/config | base64 -w 0
```

## Docker Registry (GitHub Container Registry)

```
GITHUB_TOKEN=automatically_provided_by_github
```

## Optional Secrets

### Snyk Security Scanning

```
SNYK_TOKEN=your_snyk_api_token
```

### Slack/Discord Notifications

```
SLACK_WEBHOOK_URL=your_slack_webhook_url
DISCORD_WEBHOOK_URL=your_discord_webhook_url
```

### CodeCov

```
CODECOV_TOKEN=your_codecov_token
```

## How to Add Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add each secret with the exact name shown above

## Environment-Specific Secrets

For different environments (dev, prod), you can use environment secrets:

**Dev Environment:**

- Go to Settings → Environments → Create "dev" environment
- Add environment-specific secrets

**Prod Environment:**

- Go to Settings → Environments → Create "prod" environment
- Add environment-specific secrets
- Enable required reviewers for production deployments
