locals {
  active_route_table_ids = {
    for key, route_table_id in var.route_table_ids : key => route_table_id
    if !contains(var.excluded_route_tables, key)
  }

  routes = merge([
    for route_table_key, route_table_id in local.active_route_table_ids : {
      for cidr in var.destination_cidrs : "${route_table_key}-${cidr}" => {
        route_table_id = route_table_id
        cidr           = cidr
      }
    }
  ]...)
}

resource "aws_route" "to_tgw" {
  for_each = local.routes

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr
  transit_gateway_id     = var.transit_gateway_id
}
