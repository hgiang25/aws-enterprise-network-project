resource "aws_security_group" "internal_workload" {
  name        = "${var.name}-internal-workload-sg"
  description = "Internal workload security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-internal-workload-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "internal_from_trusted_https" {
  for_each = toset(var.trusted_cidrs)

  security_group_id = aws_security_group.internal_workload.id
  cidr_ipv4         = each.value
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "HTTPS from trusted enterprise networks"
}

resource "aws_vpc_security_group_ingress_rule" "internal_from_trusted_icmp" {
  for_each = toset(var.trusted_cidrs)

  security_group_id = aws_security_group.internal_workload.id
  cidr_ipv4         = each.value
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
  description       = "ICMP from trusted enterprise networks for testing"
}

resource "aws_vpc_security_group_egress_rule" "internal_all_egress" {
  security_group_id = aws_security_group.internal_workload.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound traffic"
}

resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.name}-vpc-endpoint-sg"
  description = "Security group for interface VPC endpoints"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-vpc-endpoint-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "endpoint_from_vpc" {
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Allow HTTPS from VPC to endpoints"
}

resource "aws_vpc_security_group_egress_rule" "endpoint_all_egress" {
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "client_vpn" {
  name        = "${var.name}-client-vpn-sg"
  description = "Security group associated with Client VPN target networks"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-client-vpn-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "client_vpn_all_egress" {
  security_group_id = aws_security_group.client_vpn.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
