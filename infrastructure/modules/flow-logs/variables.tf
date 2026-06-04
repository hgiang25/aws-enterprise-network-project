variable "name" {
  type        = string
  description = "Name prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "retention_in_days" {
  type        = number
  description = "Log retention."
  default     = 365
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
