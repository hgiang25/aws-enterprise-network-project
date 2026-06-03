#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
cd "terraform/environments/${ENVIRONMENT}"
terraform init
terraform plan
