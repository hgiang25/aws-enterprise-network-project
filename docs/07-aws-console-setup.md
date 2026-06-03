# Manual AWS Console Setup Before Running GitHub Actions

## 1. Choose AWS region

Recommended lab region: `ap-southeast-1`.

## 2. Create the Terraform state S3 bucket

1. Open AWS Console.
2. Go to **S3**.
3. Choose **Create bucket**.
4. Bucket name example: `hgiang25-aws-enterprise-network-tfstate`.
5. Region: `ap-southeast-1`.
6. Object Ownership: **ACLs disabled**.
7. Block Public Access: keep **Block all public access** enabled.
8. Bucket Versioning: **Enable**.
9. Default encryption: **SSE-S3** is acceptable for lab; use **SSE-KMS** for stronger production control.
10. Create bucket.

Terraform workflow uses the S3 backend with `use_lockfile=true`, so DynamoDB is not required for new Terraform versions.

## 3. Create IAM OIDC provider for GitHub Actions

1. Open **IAM**.
2. Go to **Identity providers**.
3. Choose **Add provider**.
4. Provider type: **OpenID Connect**.
5. Provider URL: `https://token.actions.githubusercontent.com`.
6. Audience: `sts.amazonaws.com`.
7. Add provider.

## 4. Create IAM policy for Terraform deployment

1. Open **IAM**.
2. Go to **Policies**.
3. Choose **Create policy**.
4. Choose **JSON**.
5. Copy `bootstrap/aws-console/terraform-deploy-policy.json`.
6. Replace `REPLACE_WITH_STATE_BUCKET` with your real S3 state bucket name.
7. Policy name: `TerraformEnterpriseNetworkDeployPolicy`.
8. Create policy.

For a school/lab project, this policy is broad enough to avoid deployment failure while still separating GitHub Actions from your personal user account. For production, narrow it by resource and service boundary.

## 5. Create IAM role for GitHub Actions OIDC

1. Open **IAM**.
2. Go to **Roles**.
3. Choose **Create role**.
4. Trusted entity type: **Web identity**.
5. Identity provider: `token.actions.githubusercontent.com`.
6. Audience: `sts.amazonaws.com`.
7. Attach policy: `TerraformEnterpriseNetworkDeployPolicy`.
8. Role name: `github-actions-terraform-enterprise-network`.
9. Create role.
10. Open the role after creation.
11. Edit **Trust relationship**.
12. Use `bootstrap/aws-console/github-oidc-trust-policy.json` as a reference.
13. Replace `REPLACE_WITH_AWS_ACCOUNT_ID` with your AWS account ID.
14. Keep the repo condition as `repo:hgiang25/aws-enterprise-network-project:*`, or replace it with your real GitHub repository path.
15. Save trust policy.

## 6. Create GitHub repository environments

In GitHub repository:

1. Go to **Settings**.
2. Go to **Environments**.
3. Create environment `dev`.
4. Create environment `prod`.
5. For `prod`, enable **Required reviewers** so `terraform apply` needs manual approval.

## 7. Add GitHub environment variables

For both `dev` and `prod`, add these variables:

```text
AWS_REGION=ap-southeast-1
AWS_ROLE_TO_ASSUME=arn:aws:iam::<account-id>:role/github-actions-terraform-enterprise-network
TF_STATE_BUCKET=<your-state-bucket-name>
TF_STATE_KEY_PREFIX=aws-enterprise-network
```

Use **Variables**, not **Secrets**, because these values are not passwords. Do not add AWS access keys.

## 8. Run workflows in this order

1. Push code to `main`.
2. Check `Terraform CI`.
3. Run `Terraform Plan` manually for `dev`.
4. Review plan logs.
5. Run `Terraform Apply` manually for `dev`.
6. Confirm resources in AWS Console: VPC, Transit Gateway, NAT Gateway, CloudWatch Logs.
7. Repeat for `prod` only when dev is stable.
