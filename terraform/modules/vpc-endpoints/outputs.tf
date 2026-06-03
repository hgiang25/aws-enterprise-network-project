output "interface_endpoint_ids" {
  value       = { for k, v in aws_vpc_endpoint.interface : k => v.id }
  description = "Interface VPC endpoint IDs by service key."
}

output "s3_endpoint_id" {
  value       = aws_vpc_endpoint.s3.id
  description = "S3 gateway VPC endpoint ID."
}
