
# Terraform Project 2: S3 Bucket with Versioning

[![Project-2](https://img.shields.io/badge/Project_2-S3_Versioning-FF9900?style=for-the-badge&logo=amazon-s3&logoColor=white)](projects/beginner/02-s3-bucket-versioning/)
[![Free](https://img.shields.io/badge/Cost-Free-brightgreen?style=for-the-badge&logo=money-off&logoColor=white)](projects/beginner/02-s3-bucket-versioning/)
[![Time](https://img.shields.io/badge/Time-20min-blue?style=flat&logo=clock&logoColor=white)](projects/beginner/02-s3-bucket-versioning/)


## 🎯 Project Overview

**Level:** Beginner (Project #2/30)  
**Estimated Time:** 20 minutes  
**Cost:** **Free** (S3 Standard storage free tier eligible)  
**Real-World Use Case:** Static websites, backups, data lakes, asset storage

This project creates a **production-ready S3 bucket** with:
- Object versioning enabled
- Lifecycle policies (transition to IA, expire old versions)
- Server-side encryption (SSE-S3)
- Public bucket policy (optional static website)
- Comprehensive tagging and monitoring

## 📋 Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [File Structure](#file-structure)
- [Complete Code](#complete-code)
- [Real-time Interview Questions](#real-time-interinterview-questions)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Clean Up](#clean-up)

## ✨ Features

| Feature | Implemented | Terraform Resource |
|---------|-------------|-------------------|
| S3 Bucket | ✅ | `aws_s3_bucket` |
| Versioning | ✅ | `aws_s3_bucket_versioning` |
| Encryption | ✅ | `aws_s3_bucket_server_side_encryption_configuration` |
| Lifecycle Rules | ✅ | `aws_s3_bucket_lifecycle_configuration` |
| Public Policy | ✅ | `aws_s3_bucket_policy` |
| Static Website | ✅ | `aws_s3_bucket_website_configuration` |
| Logging | ✅ | `aws_s3_bucket_logging` |
| Tags | ✅ | `tags_all` |

## 🏗️ Architecture

```
┌─────────────────┐
│   Internet      │◄───[Public Read]─── Static Website
│                 │
└─────────┬───────┘
          │
          ▼
┌─────────────────────┐
│ S3 Bucket           │
│ • Versioning: ON    │
│ • Encryption: SSE-S3│
│ • Lifecycle: IA+Exp │
│ • Logging: Enabled  │
└─────────────────────┘
          ▲
          │ Uploads via CLI/SDK
┌─────────────────────┐
│ Your Applications   │
└─────────────────────┘
```

## 🛠️ Prerequisites

```bash
# 1. Terraform installed
terraform version

# 2. AWS CLI configured
aws s3 ls

# 3. IAM Permissions needed
- s3:CreateBucket, PutBucket*
- s3:PutObject, GetObject
- s3:DeleteObjectVersion
```

## 🚀 Quick Start

```bash
# Navigate to project
cd Terraform-30-projects/projects/beginner/02-s3-bucket-versioning

# Deploy
terraform init
terraform plan
terraform apply

# Test uploads
aws s3 cp test.txt s3://$(terraform output bucket_name)/
aws s3 cp test.txt s3://$(terraform output bucket_name)/ --website

# Visit website
open $(terraform output website_url)
```

## 📁 File Structure

```
02-s3-bucket-versioning/
├── main.tf              # Complete S3 configuration
├── variables.tf         # Customizable settings
├── outputs.tf           # Bucket URLs and names
├── terraform.tfvars     # Default values
├── test-files/          # Sample files to upload
├── README.md
└── .gitignore
```

## 📝 Complete Code

### **main.tf** (Production-Ready)
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

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
    id     = "transition-to-ia"
    status = "Enabled"
    
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    
    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }
    
    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}

# Bucket Policy (Public Read for Website)
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.project_bucket.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resources = ["${aws_s3_bucket.project_bucket.arn}/*"]
      }
    ]
  })
}

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
```

### **variables.tf**
```hcl
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Unique S3 bucket name"
  type        = string
  default     = "tf-project2-bucket-$(randomstring)"
  
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be 3-63 characters."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Project     = "Terraform-30-Projects"
    ManagedBy   = "Terraform"
    Owner       = "Learning"
  }
}
```

### **outputs.tf**
```hcl
output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.project_bucket.bucket
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.project_bucket.arn
}

output "website_url" {
  description = "Static website URL"
  value       = aws_s3_bucket_website_configuration.project_bucket_website.website_endpoint
}

output "website_domain" {
  description = "Website domain"
  value       = aws_s3_bucket_website_configuration.project_bucket_website.website_domain
}
```

## 💬 Real-time Interview Questions

### **Beginner Level**
```
Q1: Why separate aws_s3_bucket_versioning resource?
A: New AWS provider requires separate resources for sub-configurations.

Q2: What's the benefit of object versioning?
A: Recover from accidental deletes, track changes, compliance.

Q3: SSE-S3 vs SSE-KMS?
A: SSE-S3 = AWS managed keys (free). SSE-KMS = customer managed (costly).
```

### **Intermediate Level**
```
Q4: Lifecycle rule applied to noncurrent versions?
A: Yes! Old versions transition to Glacier after 90 days.

Q5: Bucket naming global uniqueness?
A: Yes, across ALL AWS accounts worldwide. Use random suffix.

Q6: Public policy security risk?
A: Only GetObject on /*. No Delete/Put. Use CloudFront + OAI for prod.
```

### **Advanced Level**
```
Q7: Cross-region replication setup?
A: aws_s3_bucket_replication_configuration + IAM replication role.

Q8: EventBridge + Lambda on object create?
A: aws_s3_bucket_notification + lambda_function.

Q9: Module-ize this bucket?
A: Pass bucket_name, tags, lifecycle_days as variables.
```

## 🧪 Testing Your Deployment

```bash
# Variables
BUCKET=$(terraform output -raw bucket_name)
WEBSITE=$(terraform output -raw website_url)

# Upload test files
echo "<h1>Terraform Project 2 Success!</h1>" > index.html
aws s3 cp index.html s3://$BUCKET/

# Test versioning (upload same file twice)
echo "Version 1" > test.txt
aws s3 cp test.txt s3://$BUCKET/
aws s3 cp test.txt s3://$BUCKET/ --metadata md5=2

# Verify website
curl $WEBSITE
open $WEBSITE

# List versions
aws s3api list-object-versions --bucket $BUCKET
```

**Expected Results:**
```
$ curl http://tf-project2-bucket-abc123.s3-website-us-east-1.amazonaws.com
<h1>Terraform Project 2 Success!</h1>
```

## ⚠️ Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `Bucket name taken` | Global name collision | Add `random_id` suffix |
| `Access denied` | Missing s3 perms | Add `AmazonS3FullAccess` |
| `Website 403` | No index.html | Upload index.html first |
| `Versioning disabled` | State drift | `terraform apply` again |

## 🧹 Clean Up

```bash
# Destroy (empties bucket first)
terraform destroy -auto-approve

# Manual cleanup if needed
aws s3 rb s3://$BUCKET --force
```

## 🎓 Next Steps

1. **[Project 3]** VPC + Public Subnet (Networking)
2. **Learn:** `for_each`, `count`, bucket replication
3. **Practice:** Add CloudFront CDN distribution
4. **Advanced:** Multi-region replication setup

## 📄 License
MIT License - Free for learning/portfolio

***

**⭐ Star: https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects**  
**🐛 Issues: [Create Issue](https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects/issues/new)**

*Updated: Jan 2026* 





