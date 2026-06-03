variable "route_table_ids" {
  description = "Route table IDs that need routes to Transit Gateway."
  type        = map(string)
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID."
  type        = string
}

variable "destination_cidrs" {
  description = "CIDR blocks routed through Transit Gateway."
  type        = list(string)
}

variable "excluded_route_tables" {
  description = "Route table keys excluded from TGW routes, useful for guest internet-only subnet."
  type        = set(string)
  default     = []
}
