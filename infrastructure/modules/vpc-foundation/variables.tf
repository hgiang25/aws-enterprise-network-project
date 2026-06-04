variable "name" {
  type        = string
  description = "Name prefix."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones."
}

variable "public_subnets" {
  type = map(object({
    cidr     = string
    az_index = number
  }))
  description = "Public subnets."
}

variable "private_subnets" {
  type = map(object({
    cidr     = string
    az_index = number
    segment  = string
  }))
  description = "Private subnets."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT Gateways."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single NAT Gateway."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
