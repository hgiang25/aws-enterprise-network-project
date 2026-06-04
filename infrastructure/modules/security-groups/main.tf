resource "aws_security_group" "internal_workload" {
  name        = "${var.name}-internal-workload-sg"
  description = "Internal workload security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow trusted enterprise CIDRs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = distinct(concat([var.vpc_cidr], var.trusted_cidrs))
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-internal-workload-sg"
  })
}

resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.name}-vpce-sg"
  description = "Security group for interface VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC and trusted CIDRs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = distinct(concat([var.vpc_cidr], var.trusted_cidrs))
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-vpce-sg"
  })
}

resource "aws_security_group" "client_vpn" {
  name        = "${var.name}-client-vpn-sg"
  description = "Security group for Client VPN"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow VPN users to enterprise network"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = distinct(concat([var.vpc_cidr], var.trusted_cidrs))
  }

  tags = merge(var.tags, {
    Name = "${var.name}-client-vpn-sg"
  })
}
