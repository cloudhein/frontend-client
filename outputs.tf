# -------------------------------------------------------------------------
# Outputs for the S3 Backend Bucket (Terraform State)
# -------------------------------------------------------------------------
output "s3_backend_bucket_id" {
  description = "The name of the backend S3 bucket"
  value       = aws_s3_bucket.s3_backend.id
}

output "s3_backend_bucket_arn" {
  description = "The ARN of the backend S3 bucket"
  value       = aws_s3_bucket.s3_backend.arn
}

output "frontend_website_domain" {
  description = "The domain of the website endpoint"
  value       = aws_s3_bucket_website_configuration.frontend.website_domain
}