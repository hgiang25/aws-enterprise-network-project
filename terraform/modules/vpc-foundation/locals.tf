locals {
  public_subnet_keys = keys(var.public_subnets)
  first_public_key   = local.public_subnet_keys[0]

  nat_gateway_subnets = var.single_nat_gateway ? {
    (local.first_public_key) = var.public_subnets[local.first_public_key]
  } : var.public_subnets

  private_nat_key = {
    for private_key, private_subnet in var.private_subnets :
    private_key => (
      var.single_nat_gateway ? local.first_public_key : coalesce(
        try(element([
          for public_key, public_subnet in var.public_subnets : public_key
          if public_subnet.az_index == private_subnet.az_index
        ], 0), null),
        local.first_public_key
      )
    )
  }
}
