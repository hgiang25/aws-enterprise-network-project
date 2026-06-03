resource "aws_kms_key" "logs" {
  description             = "KMS key for ${var.name} Client VPN logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.tags, {
    Name = "${var.name}-logs-kms"
  })
}

resource "aws_kms_alias" "logs" {
  name          = "alias/${var.name}-client-vpn-logs"
  target_key_id = aws_kms_key.logs.key_id
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/client-vpn/${var.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = aws_kms_key.logs.arn

  tags = merge(var.tags, {
    Name = "${var.name}-client-vpn-logs"
  })
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "connection-log"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = "Enterprise remote access Client VPN"
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  security_group_ids     = var.security_group_ids
  dns_servers            = var.dns_servers

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
  description            = "Allow VPN clients to access ${each.value}"
}
