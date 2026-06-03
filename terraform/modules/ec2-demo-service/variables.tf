variable "name" {
  type        = string
  description = "Name of the EC2 demo service."
}

variable "subnet_id" {
  type        = string
  description = "Private subnet ID where the EC2 demo instance is deployed."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs attached to the EC2 demo instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the demo service."
  default     = "t3.micro"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to EC2 demo resources."
  default     = {}
}