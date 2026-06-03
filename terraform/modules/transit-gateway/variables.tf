variable "name" {
  type        = string
  description = "Transit Gateway name."
}

variable "amazon_side_asn" {
  type        = number
  description = "Private ASN for the AWS side of the Transit Gateway."
  default     = 64512
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
  type        = map(string)
  description = "Common tags."
  default     = {}
}
