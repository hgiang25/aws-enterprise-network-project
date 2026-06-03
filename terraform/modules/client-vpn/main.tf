resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/client-vpn/${var.name}"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "connections"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = "${var.name} remote access VPN"
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  security_group_ids     = var.security_group_ids
  dns_servers            = var.dns_servers
  transport_protocol     = "udp"
  vpn_port               = 443

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.root_certificate_chain_arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.this.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.this.name
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
}

resource "aws_ec2_client_vpn_route" "this" {
  for_each = {
    for pair in flatten([
      for subnet_id in var.target_subnet_ids : [
        for cidr in var.authorization_cidrs : {
          key       = "${subnet_id}-${replace(replace(cidr, "/", "-"), ".", "-")}"
          subnet_id = subnet_id
          cidr      = cidr
        }
      ]
    ]) : pair.key => pair
  }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = each.value.cidr
  target_vpc_subnet_id   = each.value.subnet_id

  depends_on = [aws_ec2_client_vpn_network_association.this]
}
