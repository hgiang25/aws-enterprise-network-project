variable "name" {
  description = "Name prefix for the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones used by this VPC."
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet definitions."
  type = map(object({
    cidr     = string
    az_index = number
  }))
  default = {}
}

variable "private_subnets" {
  description = "Private subnet definitions."
  type = map(object({
    cidr     = string
    az_index = number
    segment  = string
  }))
  default = {}
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway for private subnet outbound Internet."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one NAT Gateway for all private subnets. For production, set false."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
