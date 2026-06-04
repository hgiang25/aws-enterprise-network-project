# Deployment Guide

## 1. Configure GitHub secrets

Add these repository secrets:

```text
AWS_ACCESS_KEY
AWS_SECRET_KEY
```

## 2. Run bootstrap

```text
Actions → Terraform Bootstrap → Run workflow
```

This creates the Terraform S3 state bucket using Terraform.

## 3. Deploy the network

```text
Actions → Terraform Infrastructure Deploy → Run workflow
action = apply
```

## 4. Destroy the network

```text
Actions → Terraform Infrastructure Destroy → Run workflow
confirm_destroy = DESTROY
```

## 5. Local commands

```bash
cd infrastructure/bootstrap
terraform init
terraform apply

cd ../environments/aws_network
terraform init
terraform plan
terraform apply
```
