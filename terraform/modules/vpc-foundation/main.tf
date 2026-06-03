resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = var.azs[each.value.az_index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = var.azs[each.value.az_index]

  tags = merge(var.tags, {
    Name    = "${var.name}-${each.key}"
    Tier    = "private"
    Segment = each.value.segment
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateway ? (var.single_nat_gateway ? { first = values(aws_subnet.public)[0] } : aws_subnet.public) : {}

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  for_each = aws_eip.nat

  allocation_id = each.value.id
  subnet_id     = var.single_nat_gateway ? values(aws_subnet.public)[0].id : aws_subnet.public[each.key].id

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}-nat"
  })

  depends_on = [aws_internet_gateway.this]
}

locals {
  nat_gateway_ids = values(aws_nat_gateway.this)[*].id
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway && length(local.nat_gateway_ids) > 0 ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.single_nat_gateway ? local.nat_gateway_ids[0] : aws_nat_gateway.this[one([for k, v in var.public_subnets : k if v.az_index == var.private_subnets[each.key].az_index])].id
    }
  }

  tags = merge(var.tags, {
    Name    = "${var.name}-${each.key}-rt"
    Segment = var.private_subnets[each.key].segment
  })
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
