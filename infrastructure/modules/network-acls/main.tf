locals {
  department_subnets = {
    for key, subnet in var.subnets : key => subnet
    if subnet.policy == "department"
  }

  guest_subnets = {
    for key, subnet in var.subnets : key => subnet
    if subnet.policy == "guest"
  }

  branch_subnets = {
    for key, subnet in var.subnets : key => subnet
    if subnet.policy == "branch"
  }

  services_subnets = {
    for key, subnet in var.subnets : key => subnet
    if subnet.policy == "services"
  }

  internal_cidrs = distinct([
    var.main_vpc_cidr,
    var.branch_vpc_cidr,
    var.shared_vpc_cidr,
    var.client_vpn_cidr,
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ])
}

resource "aws_network_acl" "department" {
  count  = length(local.department_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-department-nacl"
    Type = "department"
  })
}

resource "aws_network_acl" "guest" {
  count  = length(local.guest_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-guest-nacl"
    Type = "guest"
  })
}

resource "aws_network_acl" "branch" {
  count  = length(local.branch_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-branch-nacl"
    Type = "branch"
  })
}

resource "aws_network_acl" "services" {
  count  = length(local.services_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-services-nacl"
    Type = "services"
  })
}

resource "aws_network_acl_association" "department" {
  for_each = local.department_subnets

  subnet_id      = each.value.subnet_id
  network_acl_id = aws_network_acl.department[0].id
}

resource "aws_network_acl_association" "guest" {
  for_each = local.guest_subnets

  subnet_id      = each.value.subnet_id
  network_acl_id = aws_network_acl.guest[0].id
}

resource "aws_network_acl_association" "branch" {
  for_each = local.branch_subnets

  subnet_id      = each.value.subnet_id
  network_acl_id = aws_network_acl.branch[0].id
}

resource "aws_network_acl_association" "services" {
  for_each = local.services_subnets

  subnet_id      = each.value.subnet_id
  network_acl_id = aws_network_acl.services[0].id
}

resource "aws_network_acl_rule" "department_inbound" {
  count = length(local.department_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.department[0].id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "department_services_outbound" {
  count = length(local.department_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.department[0].id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.shared_vpc_cidr
}

resource "aws_network_acl_rule" "department_vpn_outbound" {
  count = length(local.department_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.department[0].id
  rule_number    = 110
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.client_vpn_cidr
}

resource "aws_network_acl_rule" "department_internet_outbound" {
  count = length(local.department_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.department[0].id
  rule_number    = 300
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "guest_inbound" {
  count = length(local.guest_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.guest[0].id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "guest_deny_internal_outbound" {
  for_each = length(local.guest_subnets) > 0 ? {
    for idx, cidr in local.internal_cidrs : idx => cidr
  } : {}

  network_acl_id = aws_network_acl.guest[0].id
  rule_number    = 100 + tonumber(each.key)
  egress         = true
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = each.value
}

resource "aws_network_acl_rule" "guest_internet_outbound" {
  count = length(local.guest_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.guest[0].id
  rule_number    = 300
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "branch_inbound" {
  count = length(local.branch_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.branch[0].id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "branch_services_outbound" {
  count = length(local.branch_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.branch[0].id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.shared_vpc_cidr
}

resource "aws_network_acl_rule" "branch_internet_outbound" {
  count = length(local.branch_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.branch[0].id
  rule_number    = 300
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "services_inbound" {
  count = length(local.services_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.services[0].id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "services_outbound" {
  count = length(local.services_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.services[0].id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
