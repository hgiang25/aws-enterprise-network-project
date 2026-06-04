variable "name" {
  type        = string
  description = "Transit Gateway name."
}

variable "attachments" {
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
    vpc_cidr   = string
  }))
  description = "VPC attachments."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
