# GitHub Guide

## Suggested Repository Name

`aws-enterprise-network-infrastructure`

## First Push

```bash
git init
git add .
git commit -m "Initial enterprise network infrastructure on AWS"
git branch -M main
git remote add origin https://github.com/<username>/aws-enterprise-network-infrastructure.git
git push -u origin main
```

## CI/CD

Workflow `.github/workflows/terraform-ci.yml` chạy:

- `terraform fmt -check`
- `terraform init -backend=false`
- `terraform validate`
- Checkov IaC scan

## Branching

- `main`: stable branch.
- `dev`: active development branch.
- Pull Request bắt buộc pass CI trước khi merge.

## What Not to Commit

- `.terraform/`
- `*.tfstate`
- `*.tfvars`
- VPN/SSH certificates and keys
- AWS credentials
