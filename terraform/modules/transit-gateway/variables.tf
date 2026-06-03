variable "name" {
  type        = string
  description = "Transit Gateway name."
}

variable "attachments" {
  description = "VPC attachments keyed by logical VPC name."
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
    vpc_cidr   = string
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
