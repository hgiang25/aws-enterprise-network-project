variable "name" {
  type        = string
  description = "Name prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs."
}

variable "route_table_ids" {
  type        = list(string)
  description = "Route table IDs for gateway endpoints."
}

variable "security_group_id" {
  type        = string
  description = "Security group for interface endpoints."
}

variable "aws_region" {
  type        = string
  description = "AWS region."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
