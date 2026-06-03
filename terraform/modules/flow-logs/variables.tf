variable "name" {
  type        = string
  description = "Name prefix for VPC Flow Logs resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Flow Logs will be enabled."
}

variable "retention_in_days" {
  type        = number
  description = "CloudWatch Log Group retention period in days."
  default     = 365
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to Flow Logs resources."
  default     = {}
}
