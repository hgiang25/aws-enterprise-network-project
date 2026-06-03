output "main_vpc_id" {
  value = module.main_vpc.vpc_id
}

output "branch_vpc_id" {
  value = module.branch_vpc.vpc_id
}

output "shared_services_vpc_id" {
  value = module.shared_services_vpc.vpc_id
}

output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}

output "shared_demo_instance_private_ip" {
  value       = try(module.shared_demo_service[0].private_ip, null)
  description = "Private IP of optional EC2 demo service."
}

output "client_vpn_endpoint_id" {
  value       = try(module.client_vpn[0].client_vpn_endpoint_id, null)
  description = "Client VPN endpoint ID if enabled."
}
