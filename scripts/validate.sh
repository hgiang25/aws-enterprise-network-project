#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
TF_DIR="terraform/environments/${ENVIRONMENT}"

terraform fmt -recursive terraform
cd "${TF_DIR}"
terraform init -backend=false
terraform validate
