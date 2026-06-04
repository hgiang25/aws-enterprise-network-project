variable "project" {
  type        = string
  description = "Project name."
  default     = "aws-enterprise-network"
}

variable "deployment" {
  type        = string
  description = "Single AWS deployment name."
  default     = "aws"
}

variable "aws_region" {
  type        = string
  description = "AWS region."
  default     = "ap-southeast-1"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones used by the enterprise network."
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
  description = "Whether to create NAT Gateways for private subnet internet egress."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one NAT Gateway for cost saving. Set false for Cisco-like HA."
  default     = false
}

variable "enable_demo_service" {
  type        = bool
  description = "Create private EC2 demo service in Shared Services VPC."
  default     = true
}

variable "demo_instance_type" {
  type        = string
  description = "EC2 instance type for private demo service."
  default     = "t3.micro"
}

variable "enable_client_vpn" {
  type        = bool
  description = "Create AWS Client VPN endpoint. Requires ACM certificates."
  default     = false
}

variable "client_vpn_server_certificate_arn" {
  type        = string
  description = "ACM ARN for Client VPN server certificate."
  default     = ""
}

variable "client_vpn_root_certificate_arn" {
  type        = string
  description = "ACM ARN for Client VPN client root certificate."
  default     = ""
}

variable "client_vpn_cidr" {
  type        = string
  description = "Client CIDR for VPN users. Must not overlap VPC CIDRs."
  default     = "10.250.0.0/22"
}

variable "flow_log_retention_in_days" {
  type        = number
  description = "CloudWatch log retention in days."
  default     = 365
}
