output "internal_workload_sg_id" {
  value = aws_security_group.internal_workload.id
}

output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint.id
}

output "client_vpn_sg_id" {
  value = aws_security_group.client_vpn.id
}
