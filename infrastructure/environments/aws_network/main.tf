provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  name_prefix = "${var.project}-${var.deployment}"

  common_tags = {
    Project    = var.project
    Deployment = var.deployment
    ManagedBy  = "Terraform"
    Owner      = "network-team"
    Platform   = "enterprise-network"
  }

  main_vpc_cidr   = var.main_vpc_cidr
  branch_vpc_cidr = var.branch_vpc_cidr
  shared_vpc_cidr = var.shared_vpc_cidr

  main_public_subnets = {
    public-a = { cidr = "10.10.1.0/24", az_index = 0 }
    public-b = { cidr = "10.10.2.0/24", az_index = 1 }
  }

  main_private_subnets = {
    staff-a  = { cidr = "10.10.10.0/24", az_index = 0, segment = "STAFF" }
    dev-a    = { cidr = "10.10.20.0/24", az_index = 0, segment = "DEV" }
    tester-a = { cidr = "10.10.30.0/24", az_index = 0, segment = "TESTER" }
    hr-b     = { cidr = "10.10.40.0/24", az_index = 1, segment = "HR" }
    ba-b     = { cidr = "10.10.50.0/24", az_index = 1, segment = "BA" }
    pm-b     = { cidr = "10.10.60.0/24", az_index = 1, segment = "PM" }
    tech-a   = { cidr = "10.10.70.0/24", az_index = 0, segment = "TECH" }
    guest-b  = { cidr = "10.10.80.0/24", az_index = 1, segment = "GUEST" }
    ceo-a    = { cidr = "10.10.90.0/24", az_index = 0, segment = "CEO" }
  }

  branch_public_subnets = {
    public-a = { cidr = "10.20.1.0/24", az_index = 0 }
    public-b = { cidr = "10.20.2.0/24", az_index = 1 }
  }

  branch_private_subnets = {
    br-staff-a = { cidr = "10.20.20.0/24", az_index = 0, segment = "BR-STAFF" }
    br-it-b    = { cidr = "10.20.30.0/24", az_index = 1, segment = "BR-IT" }
  }

  shared_public_subnets = {
    public-a = { cidr = "10.30.1.0/24", az_index = 0 }
    public-b = { cidr = "10.30.2.0/24", az_index = 1 }
  }

  shared_private_subnets = {
    services-a = { cidr = "10.30.10.0/24", az_index = 0, segment = "SERVICES" }
    mgmt-b     = { cidr = "10.30.20.0/24", az_index = 1, segment = "MGMT" }
  }
}

module "main_vpc" {
  source = "../../modules/vpc-foundation"

  name               = "${local.name_prefix}-main"
  vpc_cidr           = local.main_vpc_cidr
  azs                = var.azs
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  public_subnets     = local.main_public_subnets
  private_subnets    = local.main_private_subnets
  tags               = local.common_tags
}

module "branch_vpc" {
  source = "../../modules/vpc-foundation"

  name               = "${local.name_prefix}-branch"
  vpc_cidr           = local.branch_vpc_cidr
  azs                = var.azs
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  public_subnets     = local.branch_public_subnets
  private_subnets    = local.branch_private_subnets
  tags               = local.common_tags
}

module "shared_services_vpc" {
  source = "../../modules/vpc-foundation"

  name               = "${local.name_prefix}-shared"
  vpc_cidr           = local.shared_vpc_cidr
  azs                = var.azs
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  public_subnets     = local.shared_public_subnets
  private_subnets    = local.shared_private_subnets
  tags               = local.common_tags
}

module "transit_gateway" {
  source = "../../modules/transit-gateway"

  name = "${local.name_prefix}-tgw"

  attachments = {
    main = {
      vpc_id     = module.main_vpc.vpc_id
      subnet_ids = [module.main_vpc.private_subnet_ids["staff-a"], module.main_vpc.private_subnet_ids["hr-b"]]
      vpc_cidr   = module.main_vpc.vpc_cidr
    }
    branch = {
      vpc_id     = module.branch_vpc.vpc_id
      subnet_ids = values(module.branch_vpc.private_subnet_ids)
      vpc_cidr   = module.branch_vpc.vpc_cidr
    }
    shared = {
      vpc_id     = module.shared_services_vpc.vpc_id
      subnet_ids = values(module.shared_services_vpc.private_subnet_ids)
      vpc_cidr   = module.shared_services_vpc.vpc_cidr
    }
  }

  tags = local.common_tags
}

module "main_tgw_routes" {
  source = "../../modules/vpc-tgw-routes"

  route_table_ids       = module.main_vpc.private_route_table_ids
  transit_gateway_id    = module.transit_gateway.transit_gateway_id
  destination_cidrs     = [local.shared_vpc_cidr]
  excluded_route_tables = ["guest-b"]

  depends_on = [module.transit_gateway]
}

module "branch_tgw_routes" {
  source = "../../modules/vpc-tgw-routes"

  route_table_ids    = module.branch_vpc.private_route_table_ids
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  destination_cidrs  = [local.shared_vpc_cidr]

  depends_on = [module.transit_gateway]
}

module "shared_tgw_routes" {
  source = "../../modules/vpc-tgw-routes"

  route_table_ids    = module.shared_services_vpc.private_route_table_ids
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  destination_cidrs  = [local.main_vpc_cidr, local.branch_vpc_cidr]

  depends_on = [module.transit_gateway]
}

module "main_security" {
  source = "../../modules/security-groups"

  name          = "${local.name_prefix}-main"
  vpc_id        = module.main_vpc.vpc_id
  vpc_cidr      = module.main_vpc.vpc_cidr
  trusted_cidrs = [local.shared_vpc_cidr, var.client_vpn_cidr]
  tags          = local.common_tags
}

module "branch_security" {
  source = "../../modules/security-groups"

  name          = "${local.name_prefix}-branch"
  vpc_id        = module.branch_vpc.vpc_id
  vpc_cidr      = module.branch_vpc.vpc_cidr
  trusted_cidrs = [local.shared_vpc_cidr, var.client_vpn_cidr]
  tags          = local.common_tags
}

module "shared_security" {
  source = "../../modules/security-groups"

  name          = "${local.name_prefix}-shared"
  vpc_id        = module.shared_services_vpc.vpc_id
  vpc_cidr      = module.shared_services_vpc.vpc_cidr
  trusted_cidrs = [local.main_vpc_cidr, local.branch_vpc_cidr, var.client_vpn_cidr]
  tags          = local.common_tags
}

module "main_network_acls" {
  source = "../../modules/network-acls"

  name            = "${local.name_prefix}-main"
  vpc_id          = module.main_vpc.vpc_id
  main_vpc_cidr   = local.main_vpc_cidr
  branch_vpc_cidr = local.branch_vpc_cidr
  shared_vpc_cidr = local.shared_vpc_cidr
  client_vpn_cidr = var.client_vpn_cidr

  subnets = {
    for key, subnet in local.main_private_subnets : key => {
      subnet_id = module.main_vpc.private_subnet_ids[key]
      cidr      = subnet.cidr
      policy    = key == "guest-b" ? "guest" : "department"
    }
  }

  tags = local.common_tags
}

module "branch_network_acls" {
  source = "../../modules/network-acls"

  name            = "${local.name_prefix}-branch"
  vpc_id          = module.branch_vpc.vpc_id
  main_vpc_cidr   = local.main_vpc_cidr
  branch_vpc_cidr = local.branch_vpc_cidr
  shared_vpc_cidr = local.shared_vpc_cidr
  client_vpn_cidr = var.client_vpn_cidr

  subnets = {
    for key, subnet in local.branch_private_subnets : key => {
      subnet_id = module.branch_vpc.private_subnet_ids[key]
      cidr      = subnet.cidr
      policy    = "branch"
    }
  }

  tags = local.common_tags
}

module "shared_network_acls" {
  source = "../../modules/network-acls"

  name            = "${local.name_prefix}-shared"
  vpc_id          = module.shared_services_vpc.vpc_id
  main_vpc_cidr   = local.main_vpc_cidr
  branch_vpc_cidr = local.branch_vpc_cidr
  shared_vpc_cidr = local.shared_vpc_cidr
  client_vpn_cidr = var.client_vpn_cidr

  subnets = {
    for key, subnet in local.shared_private_subnets : key => {
      subnet_id = module.shared_services_vpc.private_subnet_ids[key]
      cidr      = subnet.cidr
      policy    = "services"
    }
  }

  tags = local.common_tags
}

module "shared_vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  name              = "${local.name_prefix}-shared"
  vpc_id            = module.shared_services_vpc.vpc_id
  subnet_ids        = values(module.shared_services_vpc.private_subnet_ids)
  route_table_ids   = values(module.shared_services_vpc.private_route_table_ids)
  security_group_id = module.shared_security.vpc_endpoint_sg_id
  aws_region        = var.aws_region
  tags              = local.common_tags
}

module "main_flow_logs" {
  source = "../../modules/flow-logs"

  name              = "${local.name_prefix}-main"
  vpc_id            = module.main_vpc.vpc_id
  retention_in_days = var.flow_log_retention_in_days
  tags              = local.common_tags
}

module "branch_flow_logs" {
  source = "../../modules/flow-logs"

  name              = "${local.name_prefix}-branch"
  vpc_id            = module.branch_vpc.vpc_id
  retention_in_days = var.flow_log_retention_in_days
  tags              = local.common_tags
}

module "shared_flow_logs" {
  source = "../../modules/flow-logs"

  name              = "${local.name_prefix}-shared"
  vpc_id            = module.shared_services_vpc.vpc_id
  retention_in_days = var.flow_log_retention_in_days
  tags              = local.common_tags
}

module "shared_demo_service" {
  count  = var.enable_demo_service ? 1 : 0
  source = "../../modules/ec2-demo-service"

  name               = "${local.name_prefix}-shared-demo"
  subnet_id          = module.shared_services_vpc.private_subnet_ids["services-a"]
  security_group_ids = [module.shared_security.internal_workload_sg_id]
  instance_type      = var.demo_instance_type
  tags               = local.common_tags
}

module "client_vpn" {
  count  = var.enable_client_vpn ? 1 : 0
  source = "../../modules/client-vpn"

  name                       = "${local.name_prefix}-client-vpn"
  client_cidr_block          = var.client_vpn_cidr
  server_certificate_arn     = var.client_vpn_server_certificate_arn
  root_certificate_chain_arn = var.client_vpn_root_certificate_arn

  target_subnet_ids   = values(module.shared_services_vpc.private_subnet_ids)
  security_group_ids  = [module.shared_security.client_vpn_sg_id]
  authorization_cidrs = [local.main_vpc_cidr, local.branch_vpc_cidr, local.shared_vpc_cidr]
  route_cidrs         = [local.main_vpc_cidr, local.branch_vpc_cidr, local.shared_vpc_cidr]
  dns_servers         = []
  split_tunnel        = true
  retention_in_days   = var.flow_log_retention_in_days
  tags                = local.common_tags
}
