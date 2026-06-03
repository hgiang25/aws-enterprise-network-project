variable "name" {
  type        = string
  description = "Name prefix for the Client VPN endpoint."
}

variable "client_cidr_block" {
  type        = string
  description = "CIDR block assigned to VPN clients. Must not overlap with VPC CIDRs."
}

variable "server_certificate_arn" {
  type        = string
  description = "ACM ARN of the server certificate for AWS Client VPN."
}

variable "root_certificate_chain_arn" {
  type        = string
  description = "ACM ARN of the client root certificate chain for certificate authentication."
}

variable "target_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs associated with the Client VPN endpoint."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups associated with the Client VPN endpoint."
}

variable "authorization_cidrs" {
  type        = list(string)
  description = "CIDR ranges that VPN clients are authorized to access."
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers pushed to VPN clients."
  default     = []
}

variable "split_tunnel" {
  type        = bool
  description = "Whether split tunnel mode is enabled for Client VPN."
  default     = true
}

variable "retention_in_days" {
  type        = number
  description = "Client VPN CloudWatch Log Group retention period in days."
  default     = 365
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to Client VPN resources."
  default     = {}
}
