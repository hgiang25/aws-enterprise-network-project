output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID."
}

output "vpc_cidr" {
  value       = aws_vpc.this.cidr_block
  description = "VPC CIDR block."
}

output "public_subnet_ids" {
  value       = { for k, v in aws_subnet.public : k => v.id }
  description = "Public subnet IDs by name."
}

output "private_subnet_ids" {
  value       = { for k, v in aws_subnet.private : k => v.id }
  description = "Private subnet IDs by name."
}

output "private_route_table_ids" {
  value       = { for k, v in aws_route_table.private : k => v.id }
  description = "Private route table IDs by private subnet name."
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "Public route table ID."
}
