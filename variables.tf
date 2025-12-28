variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
  default     = "flextrack-frontend-prod-01"
}

####### profile to authenticate to aws #######

variable "aws_auth_profile" {
  type        = string
  description = "AWS profile to use for authentication"
  default     = "admin-cli"
}

variable "aws_auth_region" {
  type        = string
  description = "AWS region to use for authentication"
  default     = "ap-southeast-1"
}