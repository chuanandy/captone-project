# secure-k8s-node-api-devsecops

Secure DevSecOps pipeline example using:
- Kubernetes (EKS)
- Helm
- Snyk
- GitHub Actions with OIDC (no long-lived AWS keys)
- Separate staging & production environments
- Terraform (optional) for infra

## Structure
See full folder structure in repository root.

## Quickstart (developer)

1. Clone the repo
2. Build locally:
   ```
   cd app
   npm ci
   npm start
   ```
3. Docker (local):
   ```
   docker build -t secure-node-api:dev .
   docker run -p 3000:3000 secure-node-api:dev
   ```

## Helm (local test)
```
helm upgrade --install api charts/api -n staging --create-namespace -f charts/api/values-staging.yaml
```

## GitHub Actions
- `ci.yml` runs on PRs to develop (lint, test, Snyk)
- `cd-staging.yml` runs on push to develop
- `cd-production.yml` runs on push to main

## AWS / OIDC Setup (high level)
1. Create OIDC provider in AWS for GitHub (console or terraform)
2. Create IAM role with trust policy allowing GitHub Actions to assume it
3. Restrict the role to the repo and branches you need
4. Add the role ARN and other values to GitHub Secrets:
   - `AWS_ROLE_TO_ASSUME`
   - `AWS_REGION`
   - `ECR_URI_STAGING`
   - `ECR_URI_PROD`
   - `EKS_CLUSTER_STAGING`
   - `EKS_CLUSTER_PROD`
   - `SNYK_TOKEN`

## Snyk
- Add `SNYK_TOKEN` to GitHub Secrets
- CI will fail on high/critical vulnerabilities by default

## Terraform
- The `infrastructure/` folder contains basic stubs for EKS, ECR, and IAM role for OIDC.
- Expand these for production: networking, security groups, node groups, encryption, logging.

## Notes (security)
- Do NOT store AWS access keys in repo
- Use GitHub Environments for protected deployments
- Protect `main` branch (PRs + required checks)

