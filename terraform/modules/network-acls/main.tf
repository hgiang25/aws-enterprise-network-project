locals {
  private_blocked_cidrs = {
    for subnet_key, subnet_id in var.private_subnet_ids : subnet_key => distinct(
      concat(
        var.isolate_private_subnets ? [var.vpc_cidr] : [],
        contains(var.guest_subnet_keys, subnet_key) ? var.guest_blocked_cidrs : []
      )
    )
  }

  private_deny_rules = merge([
    for subnet_key, cidrs in local.private_blocked_cidrs : {
      for index, cidr in cidrs : "${subnet_key}-${index}" => {
        subnet_key  = subnet_key
        cidr        = cidr
        rule_number = 80 + index
      }
    }
  ]...)
}

resource "aws_network_acl" "public" {
  vpc_id     = var.vpc_id
  subnet_ids = values(var.public_subnet_ids)

  tags = merge(var.tags, {
    Name = "${var.name}-public-nacl"
    Tier = "public"
  })
}

resource "aws_network_acl_rule" "public_ingress_allow_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_egress_allow_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl" "private" {
  for_each = var.private_subnet_ids

  vpc_id     = var.vpc_id
  subnet_ids = [each.value]

  tags = merge(var.tags, {
    Name    = "${var.name}-${each.key}-nacl"
    Tier    = "private"
    Segment = each.key
  })
}

resource "aws_network_acl_rule" "private_ingress_deny_internal" {
  for_each = local.private_deny_rules

  network_acl_id = aws_network_acl.private[each.value.subnet_key].id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = each.value.cidr
}

resource "aws_network_acl_rule" "private_egress_deny_internal" {
  for_each = local.private_deny_rules

  network_acl_id = aws_network_acl.private[each.value.subnet_key].id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = each.value.cidr
}

resource "aws_network_acl_rule" "private_ingress_allow_all" {
  for_each = aws_network_acl.private

  network_acl_id = each.value.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_egress_allow_all" {
  for_each = aws_network_acl.private

  network_acl_id = each.value.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
