output "department_network_acl_id" {
  value       = try(aws_network_acl.department[0].id, null)
  description = "Department NACL ID."
}

output "guest_network_acl_id" {
  value       = try(aws_network_acl.guest[0].id, null)
  description = "Guest NACL ID."
}

output "branch_network_acl_id" {
  value       = try(aws_network_acl.branch[0].id, null)
  description = "Branch NACL ID."
}

output "services_network_acl_id" {
  value       = try(aws_network_acl.services[0].id, null)
  description = "Services NACL ID."
}
