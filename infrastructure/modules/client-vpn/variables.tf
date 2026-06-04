variable "name" {
  type        = string
  description = "Name prefix."
}

variable "client_cidr_block" {
  type        = string
  description = "Client IPv4 CIDR block."
}

variable "server_certificate_arn" {
  type        = string
  description = "ACM server certificate ARN."
}

variable "root_certificate_chain_arn" {
  type        = string
  description = "ACM root certificate chain ARN."
}

variable "target_subnet_ids" {
  type        = list(string)
  description = "Subnets to associate with the Client VPN endpoint."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for Client VPN."
}

variable "authorization_cidrs" {
  type        = list(string)
  description = "CIDRs that VPN clients are authorized to access."
}

variable "route_cidrs" {
  type        = list(string)
  description = "CIDRs routed through Client VPN."
  default     = []
}

variable "dns_servers" {
  type        = list(string)
  description = "Optional DNS servers."
  default     = []
}

variable "split_tunnel" {
  type        = bool
  description = "Enable split tunnel."
  default     = true
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
