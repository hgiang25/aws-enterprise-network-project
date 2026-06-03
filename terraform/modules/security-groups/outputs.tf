output "internal_workload_sg_id" {
  value       = aws_security_group.internal_workload.id
  description = "Internal workload security group ID."
}

output "vpc_endpoint_sg_id" {
  value       = aws_security_group.vpc_endpoint.id
  description = "VPC endpoint security group ID."
}

output "client_vpn_sg_id" {
  value       = aws_security_group.client_vpn.id
  description = "Client VPN security group ID."
}
