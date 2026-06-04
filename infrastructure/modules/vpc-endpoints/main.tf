locals {
  interface_services = {
    ssm         = "com.amazonaws.${var.aws_region}.ssm"
    ssmmessages = "com.amazonaws.${var.aws_region}.ssmmessages"
    ec2messages = "com.amazonaws.${var.aws_region}.ec2messages"
    logs        = "com.amazonaws.${var.aws_region}.logs"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_services

  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [var.security_group_id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}-endpoint"
  })
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(var.tags, {
    Name = "${var.name}-s3-endpoint"
  })
}
