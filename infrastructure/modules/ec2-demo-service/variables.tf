variable "name" {
  type        = string
  description = "Name prefix."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs."
}

variable "instance_type" {
  type        = string
  description = "Instance type."
  default     = "t3.micro"
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
