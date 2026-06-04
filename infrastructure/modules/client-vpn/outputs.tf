output "client_vpn_endpoint_id" {
  value       = aws_ec2_client_vpn_endpoint.this.id
  description = "Client VPN endpoint ID."
}

output "client_vpn_dns_name" {
  value       = aws_ec2_client_vpn_endpoint.this.dns_name
  description = "Client VPN endpoint DNS name."
}
