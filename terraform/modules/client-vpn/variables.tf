variable "name" { type = string }
variable "client_cidr_block" { type = string }
variable "server_certificate_arn" { type = string }
variable "root_certificate_chain_arn" { type = string }
variable "target_subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "authorization_cidrs" { type = list(string) }
variable "dns_servers" { type = list(string) default = [] }
variable "split_tunnel" { type = bool default = true }
variable "tags" { type = map(string) default = {} }
