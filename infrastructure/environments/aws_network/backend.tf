terraform {
  backend "s3" {
    bucket       = "terraform-state-enterprise-network-248195880649"
    key          = "aws_network/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
