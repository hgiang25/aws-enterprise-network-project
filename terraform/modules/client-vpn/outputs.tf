output "client_vpn_endpoint_id" {
  value       = aws_ec2_client_vpn_endpoint.this.id
  description = "Client VPN endpoint ID."
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "Client VPN CloudWatch log group name."
}
