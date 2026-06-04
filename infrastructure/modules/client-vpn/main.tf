resource "aws_cloudwatch_log_group" "client_vpn" {
  name              = "/aws/client-vpn/${var.name}"
  retention_in_days = var.retention_in_days

  tags = merge(var.tags, {
    Name = "${var.name}-client-vpn-logs"
  })
}

resource "aws_cloudwatch_log_stream" "client_vpn" {
  name           = "connection-log"
  log_group_name = aws_cloudwatch_log_group.client_vpn.name
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = var.name
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  security_group_ids     = var.security_group_ids

  # dns_servers is an argument, not a nested block.
  # Use null when the list is empty so Terraform omits it.
  dns_servers = length(var.dns_servers) > 0 ? var.dns_servers : null

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.root_certificate_chain_arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.client_vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.client_vpn.name
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ec2_client_vpn_network_association" "this" {
  for_each = toset(var.target_subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "this" {
  for_each = toset(var.authorization_cidrs)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = each.value
  authorize_all_groups   = true

  depends_on = [aws_ec2_client_vpn_network_association.this]
}

resource "aws_ec2_client_vpn_route" "this" {
  for_each = {
    for pair in flatten([
      for subnet_id in var.target_subnet_ids : [
        for cidr in var.route_cidrs : {
          key       = "${subnet_id}-${cidr}"
          subnet_id = subnet_id
          cidr      = cidr
        }
      ]
    ]) : pair.key => pair
  }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = each.value.cidr
  target_vpc_subnet_id   = each.value.subnet_id

  depends_on = [
    aws_ec2_client_vpn_network_association.this,
    aws_ec2_client_vpn_authorization_rule.this
  ]
}