variable "project" {
  type        = string
  description = "Project name."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "aws_region" {
  type        = string
  description = "AWS region."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones."
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Whether to create NAT Gateways."
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Use a single NAT Gateway to reduce cost."
}

variable "enable_demo_service" {
  type        = bool
  default     = true
  description = "Create a private EC2 demo service in Shared Services VPC."
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
