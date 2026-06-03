variable "route_table_ids" {
  type        = map(string)
  description = "Route table IDs keyed by subnet name."
}

variable "transit_gateway_id" {
  type        = string
  description = "Transit Gateway ID."
}

variable "destination_cidrs" {
  type        = list(string)
  description = "CIDR blocks routed to Transit Gateway."
}

variable "excluded_route_tables" {
  type        = list(string)
  description = "Route table keys excluded from TGW routing, for example Guest."
  default     = []
}
