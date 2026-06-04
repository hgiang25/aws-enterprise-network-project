output "public_network_acl_id" {
  value       = aws_network_acl.public.id
  description = "Public Network ACL ID."
}

output "private_network_acl_ids" {
  value       = { for key, nacl in aws_network_acl.private : key => nacl.id }
  description = "Private Network ACL IDs by subnet key."
}
