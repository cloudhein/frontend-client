#1. Creating remote s3 backend for static website
resource "aws_s3_bucket" "s3_backend" {
  bucket        = var.s3_bucket_name
  force_destroy = true # setting boolean value to true is dangerous in production environment for it will delete your remote backend s3 immediately without asking your permission

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Dev"
  }
}

# 2. Enable ACL for S3 Bucket
resource "aws_s3_bucket_ownership_controls" "s3_backend_ownership_controls" {
  bucket = aws_s3_bucket.s3_backend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "aws-master-s3-bucket-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_backend_ownership_controls]

  bucket = aws_s3_bucket.s3_backend.id
  acl    = "private"
}

# 3. Unblock Public Access (Corresponds to "Uncheck Block all public access")
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.s3_backend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Enable Versioning for Remote Backend S3 Bucket
resource "aws_s3_bucket_versioning" "s3_backend_bucket_versioning" {
  bucket = aws_s3_bucket.s3_backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 5. Configure Static Website Hosting
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.s3_backend.id

  index_document {
    suffix = "index.html"
  }

  # Crucial for React Router: Point 404 errors to index.html
  error_document {
    key = "index.html"
  }
}

# 6. Bucket Policy (The JSON policy you manually pasted)
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.s3_backend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.s3_backend.arn}/*"
      },
    ]
  })

  # Ensure public access block is removed BEFORE applying the policy, 
  # otherwise AWS will reject this "public" policy.
  depends_on = [aws_s3_bucket_public_access_block.frontend]
}