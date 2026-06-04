output "client_vpn_endpoint_id" {
  value       = aws_ec2_client_vpn_endpoint.this.id
  description = "Client VPN endpoint ID."
}

output "client_vpn_dns_name" {
  value       = aws_ec2_client_vpn_endpoint.this.dns_name
  description = "Client VPN endpoint DNS name."
}

output "generated_ca_certificate_pem" {
  value       = try(tls_self_signed_cert.ca[0].cert_pem, null)
  description = "Generated CA certificate PEM for lab Client VPN."
  sensitive   = true
}

output "generated_client_certificate_pem" {
  value       = try(tls_locally_signed_cert.client[0].cert_pem, null)
  description = "Generated client certificate PEM for lab Client VPN."
  sensitive   = true
}

output "generated_client_private_key_pem" {
  value       = try(tls_private_key.client[0].private_key_pem, null)
  description = "Generated client private key PEM for lab Client VPN."
  sensitive   = true
}