variable "name" {
  type        = string
  description = "Name prefix for Network ACL resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "vpc_cidr" {
  type        = string
  description = "Local VPC CIDR block."
}

variable "public_subnet_ids" {
  type        = map(string)
  description = "Public subnet IDs by subnet key."
}

variable "private_subnet_ids" {
  type        = map(string)
  description = "Private subnet IDs by subnet key."
}

variable "isolate_private_subnets" {
  type        = bool
  description = "When true, deny direct traffic between private subnets in the same VPC at the NACL layer."
  default     = false
}

variable "guest_subnet_keys" {
  type        = list(string)
  description = "Private subnet keys treated as guest/internet-only networks."
  default     = []
}

variable "guest_blocked_cidrs" {
  type        = list(string)
  description = "CIDR ranges that guest subnets must not access."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}
