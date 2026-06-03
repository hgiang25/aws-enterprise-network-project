# Keep backend disabled for local labs.
# To enable remote state, uncomment this block and run:
# terraform init -reconfigure \
#   -backend-config="bucket=<your-state-bucket>" \
#   -backend-config="key=aws-enterprise-network/dev/terraform.tfstate" \
#   -backend-config="region=ap-southeast-1" \
#   -backend-config="dynamodb_table=<your-lock-table>" \
#   -backend-config="encrypt=true"
#
# terraform {
#   backend "s3" {}
# }
