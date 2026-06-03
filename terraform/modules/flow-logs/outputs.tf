output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "CloudWatch Log Group name for VPC Flow Logs."
}

output "kms_key_arn" {
  value       = aws_kms_key.logs.arn
  description = "KMS key ARN used for log encryption."
}
