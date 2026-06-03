# Fully Automated Deployment Guide

This version follows the same deployment style as the previous DevOps project: no manual AWS Console setup is required for the network infrastructure itself.

## 1. One-time GitHub setup

Create two repository secrets:

```text
AWS_ACCESS_KEY
AWS_SECRET_KEY
```

These secrets are used by GitHub Actions through `aws-actions/configure-aws-credentials`.

## 2. Bootstrap backend automatically

Run:

```text
Actions → Terraform Bootstrap → Run workflow
```

The workflow creates or imports:

```text
S3 bucket: terraform-state-enterprise-network-248195880649
DynamoDB table: terraform-lock-enterprise-network
```

## 3. Deploy automatically

Run:

```text
Actions → Terraform Deploy Enterprise Network → Run workflow
```

Select:

```text
environment = dev
action = apply
```

## 4. One-click bootstrap + deploy

Alternatively run:

```text
Actions → Full Deploy Enterprise Network → Run workflow
```

This runs bootstrap and deploy in the same workflow.

## 5. Production deployment

For production, run the same workflow with:

```text
environment = prod
```

## 6. Destroy lab environment

Run:

```text
Actions → Terraform Destroy Enterprise Network → Run workflow
```

Type:

```text
DESTROY
```

## 7. When bucket name is already taken

S3 bucket names are globally unique. If the bootstrap workflow fails because the bucket name is already taken, replace this value everywhere:

```text
terraform-state-enterprise-network-248195880649
```

Files to update:

```text
bootstrap/variables.tf
.github/workflows/bootstrap.yml
.github/workflows/full-deploy.yml
terraform/environments/dev/backend.tf
terraform/environments/prod/backend.tf
```
