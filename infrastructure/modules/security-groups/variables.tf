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
  description = "VPC CIDR."
}

variable "trusted_cidrs" {
  type        = list(string)
  description = "Trusted CIDRs."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
