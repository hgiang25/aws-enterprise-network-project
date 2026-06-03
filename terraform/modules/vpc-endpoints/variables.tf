variable "name" {
  type        = string
  description = "Name prefix for VPC endpoint resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where endpoints will be created."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for interface VPC endpoints."
}

variable "route_table_ids" {
  type        = list(string)
  description = "Route table IDs used by gateway VPC endpoints such as S3."
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to interface VPC endpoints."
}

variable "aws_region" {
  type        = string
  description = "AWS region used to construct VPC endpoint service names."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to VPC endpoint resources."
  default     = {}
}
