# S3 Bucket
resource "aws_s3_bucket" "project_bucket" {
  bucket = var.bucket_name

  tags = merge(var.default_tags, {
    Name        = var.bucket_name
    Environment = var.environment
  })
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "project_bucket_versioning" {
  bucket = aws_s3_bucket.project_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-Side Encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "project_bucket_encryption" {
  bucket = aws_s3_bucket.project_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle Policy
resource "aws_s3_bucket_lifecycle_configuration" "project_bucket_lifecycle" {
  bucket = aws_s3_bucket.project_bucket.id

  rule {
    id     = "delete-after-30-days"
    status = "Enabled"

    filter {
      prefix = ""  # Applies to all objects; use a specific path like "logs/" if needed
    }

    expiration {
      days = 30
    }
  }
}

/*
# Bucket Policy (Public Read for Website)
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.project_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::${aws_s3_bucket.project_bucket.id}/*"  # ✅ Correct: "Resource"
    }]
  })
}
*/

# Static Website Hosting
resource "aws_s3_bucket_website_configuration" "project_bucket_website" {
  bucket = aws_s3_bucket.project_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Server Access Logging
resource "aws_s3_bucket_logging" "project_bucket_logging" {
  bucket = aws_s3_bucket.project_bucket.id

  target_bucket = aws_s3_bucket.project_bucket.id
  target_prefix = "logs/"
}