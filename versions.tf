terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

# Configure the aws provider to authentication
provider "aws" {
  profile = var.aws_auth_profile
  region  = var.aws_auth_region
}