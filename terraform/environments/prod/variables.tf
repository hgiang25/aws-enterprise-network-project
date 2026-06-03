variable "project" {
  type        = string
  description = "Project name."
  default     = "aws-enterprise-network"
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "prod"
}

variable "aws_region" {
  type        = string
  description = "AWS region."
  default     = "ap-southeast-1"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones."
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "main_vpc_cidr" {
  type        = string
  description = "Main Office VPC CIDR."
  default     = "10.10.0.0/16"
}

variable "branch_vpc_cidr" {
  type        = string
  description = "Branch Office VPC CIDR."
  default     = "10.20.0.0/16"
}

variable "shared_vpc_cidr" {
  type        = string
  description = "Shared Services VPC CIDR."
  default     = "10.30.0.0/16"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Whether to create NAT Gateways."
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Use a single NAT Gateway to reduce cost. Set false for production-grade multi-AZ NAT."
}

variable "enable_demo_service" {
  type        = bool
  default     = true
  description = "Create a private EC2 demo service in Shared Services VPC."
}

variable "demo_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type for the demo service."
}

variable "enable_client_vpn" {
  type        = bool
  default     = false
  description = "Create AWS Client VPN endpoint. Requires ACM certificate ARNs."
}

variable "client_vpn_server_certificate_arn" {
  type        = string
  default     = ""
  description = "ACM ARN for Client VPN server certificate."
}

variable "client_vpn_root_certificate_arn" {
  type        = string
  default     = ""
  description = "ACM ARN for Client VPN client root certificate."
}

variable "client_vpn_cidr" {
  type        = string
  default     = "10.250.0.0/22"
  description = "Client CIDR for VPN users. Must not overlap VPC CIDRs."
}

variable "flow_log_retention_in_days" {
  type        = number
  default     = 365
  description = "CloudWatch log retention in days."
}
