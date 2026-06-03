variable "name" {
  type        = string
  description = "Name prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "vpc_cidr" {
  type        = string
  description = "Local VPC CIDR."
}

variable "trusted_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to access internal services."
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
