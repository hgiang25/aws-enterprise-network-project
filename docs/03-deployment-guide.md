# Deployment Guide

## 1. Configure AWS Credentials

```bash
aws configure --profile enterprise-network-dev
```

Hoặc dùng environment variables:

```bash
export AWS_PROFILE=enterprise-network-dev
export AWS_REGION=ap-southeast-1
```

## 2. Prepare Terraform Variables

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Chỉnh lại các biến cần thiết:

```hcl
project     = "aws-enterprise-network"
environment = "dev"
aws_region  = "ap-southeast-1"
```

## 3. Initialize and Validate

```bash
terraform init
terraform fmt -recursive
terraform validate
```

## 4. Plan and Apply

```bash
terraform plan
terraform apply
```

## 5. Destroy

```bash
terraform destroy
```

## 6. Enable Client VPN

Client VPN mặc định tắt. Để bật:

```hcl
enable_client_vpn = true
client_vpn_server_certificate_arn = "arn:aws:acm:...:certificate/..."
client_vpn_root_certificate_arn   = "arn:aws:acm:...:certificate/..."
```

## 7. Production Notes

Với môi trường production, nên:

- Dùng remote backend S3 + DynamoDB locking.
- Bật NAT Gateway theo nhiều AZ.
- Tách AWS account cho dev/prod.
- Bật CloudTrail, GuardDuty, AWS Config.
- Dùng CI/CD có manual approval trước `apply`.
