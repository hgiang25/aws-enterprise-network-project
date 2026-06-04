resource "aws_ec2_transit_gateway" "this" {
  description                     = var.name
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "enable"

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.attachments

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}-attachment"
  })
}
