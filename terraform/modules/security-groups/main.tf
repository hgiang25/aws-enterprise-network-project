resource "aws_security_group" "internal_workload" {
  name        = "${var.name}-internal-workload-sg"
  description = "Internal workload security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-internal-workload-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "internal_from_trusted" {
  for_each = toset(var.trusted_cidrs)

  description       = "Allow trusted enterprise CIDR ${each.value} to reach internal workloads"
  security_group_id = aws_security_group.internal_workload.id
  cidr_ipv4         = each.value
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "internal_from_self_vpc" {
  description       = "Allow local VPC CIDR to reach internal workloads"
  security_group_id = aws_security_group.internal_workload.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "internal_all_egress" {
  description       = "Allow internal workloads to initiate outbound connections"
  security_group_id = aws_security_group.internal_workload.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.name}-vpc-endpoint-sg"
  description = "Security group for interface VPC endpoints"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-vpc-endpoint-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "endpoint_https_from_vpc" {
  description       = "Allow HTTPS from local VPC to interface VPC endpoints"
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "endpoint_all_egress" {
  description       = "Allow endpoint ENIs to respond to clients"
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
  description       = "Allow Client VPN users to reach authorized private networks"
  security_group_id = aws_security_group.client_vpn.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
