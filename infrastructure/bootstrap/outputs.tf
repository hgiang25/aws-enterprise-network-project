output "state_bucket_name" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "S3 bucket used for Terraform remote state."
}
