locals {
  route_matrix = flatten([
    for rt_key, rt_id in var.route_table_ids : [
      for cidr in var.destination_cidrs : {
        key  = "${rt_key}-${replace(replace(cidr, "/", "-"), ".", "-")}"
        rt   = rt_id
        cidr = cidr
      }
    ] if !contains(var.excluded_route_tables, rt_key)
  ])
}

resource "aws_route" "to_tgw" {
  for_each = { for route in local.route_matrix : route.key => route }

  route_table_id         = each.value.rt
  destination_cidr_block = each.value.cidr
  transit_gateway_id     = var.transit_gateway_id
}
