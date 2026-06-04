locals {
  generate_certificates = var.server_certificate_arn == "" || var.root_certificate_chain_arn == ""

  effective_server_certificate_arn = local.generate_certificates ? aws_acm_certificate.server[0].arn : var.server_certificate_arn
  effective_root_certificate_arn   = local.generate_certificates ? aws_acm_certificate.client_root[0].arn : var.root_certificate_chain_arn
}

resource "tls_private_key" "ca" {
  count = local.generate_certificates ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  count = local.generate_certificates ? 1 : 0

  private_key_pem = tls_private_key.ca[0].private_key_pem

  subject {
    common_name  = "${var.name}-client-vpn-ca"
    organization = "Enterprise Network Lab"
  }

  is_ca_certificate     = true
  validity_period_hours = 87600

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth"
  ]
}

resource "tls_private_key" "server" {
  count = local.generate_certificates ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server" {
  count = local.generate_certificates ? 1 : 0

  private_key_pem = tls_private_key.server[0].private_key_pem
  dns_names       = ["server.${var.name}.clientvpn.local"]

  subject {
    common_name  = "server.${var.name}.clientvpn.local"
    organization = "Enterprise Network Lab"
  }
}

resource "tls_locally_signed_cert" "server" {
  count = local.generate_certificates ? 1 : 0

  cert_request_pem   = tls_cert_request.server[0].cert_request_pem
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth"
  ]
}

resource "tls_private_key" "client" {
  count = local.generate_certificates ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "client" {
  count = local.generate_certificates ? 1 : 0

  private_key_pem = tls_private_key.client[0].private_key_pem

  subject {
    common_name  = "client.${var.name}.clientvpn.local"
    organization = "Enterprise Network Lab"
  }
}

resource "tls_locally_signed_cert" "client" {
  count = local.generate_certificates ? 1 : 0

  cert_request_pem   = tls_cert_request.client[0].cert_request_pem
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "client_auth"
  ]
}

resource "aws_acm_certificate" "server" {
  count = local.generate_certificates ? 1 : 0

  private_key       = tls_private_key.server[0].private_key_pem
  certificate_body  = tls_locally_signed_cert.server[0].cert_pem
  certificate_chain = tls_self_signed_cert.ca[0].cert_pem

  tags = merge(var.tags, {
    Name = "${var.name}-server-certificate"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "client_root" {
  count = local.generate_certificates ? 1 : 0

  private_key      = tls_private_key.ca[0].private_key_pem
  certificate_body = tls_self_signed_cert.ca[0].cert_pem

  tags = merge(var.tags, {
    Name = "${var.name}-client-root-certificate"
  })

  lifecycle {
    create_before_destroy = true
  }
}

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
  server_certificate_arn = local.effective_server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  security_group_ids     = var.security_group_ids

  dns_servers = length(var.dns_servers) > 0 ? var.dns_servers : null

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = local.effective_root_certificate_arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.client_vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.client_vpn.name
  }

  tags = merge(var.tags, {
    Name = var.name
  })

  depends_on = [
    aws_acm_certificate.server,
    aws_acm_certificate.client_root
  ]
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