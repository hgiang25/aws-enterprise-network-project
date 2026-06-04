# AWS Enterprise Network Infrastructure

This project migrates a stable Cisco Packet Tracer enterprise network design to AWS using Terraform and GitHub Actions.

The design preserves the Cisco model's functional intent:

- Main Office network
- Branch Office network
- Shared Services / DC network
- Department segmentation
- Guest internet-only network
- Site-to-site internal routing
- NAT egress
- Remote VPN
- Network ACL and Security Group policies
- CloudWatch / VPC Flow Logs
- Automated CI/CD deployment

## Final Repository Structure

```text
.
├── .github/workflows/
│   ├── terraform-bootstrap.yml
│   ├── terraform-network-ci.yml
│   ├── terraform-infrastructure-deploy.yml
│   └── terraform-infrastructure-destroy.yml
├── infrastructure/
│   ├── bootstrap/
│   ├── environments/
│   │   └── aws_network/
│   ├── global/
│   └── modules/
├── diagrams/
├── docs/
├── scripts/
├── Makefile
└── README.md
```

## Design Style

This project follows the infrastructure style of the example project:

- `infrastructure/bootstrap` is a Terraform stack.
- `infrastructure/environments/aws_network` is the main network stack.
- `infrastructure/modules` contains reusable Terraform modules.
- S3 remote backend is created by Terraform bootstrap, not by AWS CLI scripts.
- GitHub Actions runs bootstrap first, then deploys the network stack.

## Terraform State

The bootstrap stack creates this S3 bucket:

```text
terraform-state-enterprise-network-248195880649
```

The main network stack uses:

```text
s3://terraform-state-enterprise-network-248195880649/aws_network/terraform.tfstate
```

The backend uses S3 native lock files:

```hcl
use_lockfile = true
```

No DynamoDB lock table is required.

## GitHub Secrets

Create these repository secrets:

```text
AWS_ACCESS_KEY
AWS_SECRET_KEY
```

## Workflows

Run in this order:

1. `Terraform Bootstrap`
2. `Terraform Infrastructure Deploy`

Or use `Terraform Infrastructure Deploy` directly because it has a bootstrap job first.

## Deploy

```text
Actions → Terraform Infrastructure Deploy → Run workflow
action = apply
```

## Destroy

```text
Actions → Terraform Infrastructure Destroy → Run workflow
confirm_destroy = DESTROY
```

## Cisco to AWS Mapping

| Cisco Packet Tracer | AWS |
|---|---|
| VLANs | Private subnets |
| SVI routing | VPC route tables |
| ACLs | Network ACLs + Security Groups |
| OSPF/GRE/IPsec | Transit Gateway routing |
| NAT overload | NAT Gateway |
| Remote VPN | AWS Client VPN |
| Server/DC subnet | Shared Services VPC |
| Guest internet-only | Guest subnet without TGW route + restrictive NACL |
| HSRP/R1/R2 redundancy | Multi-AZ subnets, managed TGW and multi-AZ NAT |
