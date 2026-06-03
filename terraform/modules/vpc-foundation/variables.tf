variable "name" {
  type        = string
  description = "VPC name prefix."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones used by the VPC."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create NAT Gateways."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Whether to create only one NAT Gateway for cost-saving labs."
  default     = true
}

variable "public_subnets" {
  description = "Public subnets keyed by subnet name."
  type = map(object({
    cidr     = string
    az_index = number
  }))
}

variable "private_subnets" {
  description = "Private subnets keyed by subnet name."
  type = map(object({
    cidr     = string
    az_index = number
    segment  = string
  }))
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}
