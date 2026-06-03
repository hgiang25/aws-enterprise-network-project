variable "aws_region" {
  type        = string
  description = "AWS region used for the bootstrap resources."
  default     = "ap-southeast-1"
}

variable "project" {
  type        = string
  description = "Project name used for tags."
  default     = "aws-enterprise-network"
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform remote state."
  default     = "terraform-state-enterprise-network-248195880649"
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name for Terraform state locking."
  default     = "terraform-lock-enterprise-network"
}
