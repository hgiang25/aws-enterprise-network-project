terraform {
  backend "s3" {
    bucket         = "terraform-state-enterprise-network-248195880649"
    key            = "prod/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-lock-enterprise-network"
    encrypt        = true
  }
}
