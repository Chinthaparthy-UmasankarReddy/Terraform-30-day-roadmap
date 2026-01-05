
# Terraform Project 2: S3 Bucket with Versioning
[![Project 2](https://img.shields.io/badge/Project_2-S3_Versioning-FF9900?style=for-the-badge&logo=amazon-s3&logoColor=white)](projects/beginner/02-s3-bucket-with-versioning/)
[![Terraform](https://img.shields.io/badge/Terraform-1.9.4-blue?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS_Provider-5.70.1-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/5.70.1)
[![Free](https://img.shields.io/badge/Cost-Free-brightgreen?style=for-the-badge&logo=money-off&logoColor=white)](projects/beginner/02-s3-bucket-with-versioning/)
[![Time](https://img.shields.io/badge/Time-20min-blue?style=flat&logo=clock&logoColor=white)](projects/beginner/02-s3-bucket-with-versioning/)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge&logo=license&logoColor=white)](LICENSE)
[![AIG Certified](https://img.shields.io/badge/AIG-Certified-0066cc?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTUiIGhlaWdodD0iMTUiIHZpZXdCb3g9IjAgMCAxNSAxNSIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iNy41IiBjeT0iNy41IiByPSI3LjUiIGZpbGw9IiM2NjZDQ0MiLz4KPHN2ZyB4PSIyIiB5PSIyIiB3aWR0aD0iMTEiIGhlaWdodD0iMTEiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0id2hpdGUiPgo8cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMiAydjNDNi45MiAyIDIgNi45MiAyIDEyUzYuOTIgMjAgMTIgMjBzMTAgLTkuMDggMTAtMTBTMTcuMDggMiAxMiAyWk0xMSAxN2wtNCAwIDAgLTQtNCAwIDAgNEgxMVpNMTEgMTNIMFYxMWgxMUwxNyAxMUgxOVYxM0gxMVYxN1oiLz4KPC9zdmc+Cjwvc3ZnPgo=)](https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects)


## 🎯 Project Overview

**Level:** Beginner (Project #2/30)  
**Estimated Time:** 20 minutes  
**Cost:** **Free** (S3 Standard storage free tier eligible)  
**Terraform:** **1.9.4** | **AWS Provider:** **5.70.1**  
**Real-World Use Case:** Static websites, backups, data lakes, asset storage

This project creates a **production-ready S3 bucket** with **AIG/enterprise standards**:

```
✅ Object versioning enabled
✅ Lifecycle policies (IA transition, expire old versions)  
✅ Server-side encryption (SSE-S3)
✅ Public bucket policy (static website)
✅ Comprehensive tagging and monitoring
```

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
| Ownership Controls | ✅ | `aws_s3_bucket_ownership_controls` |

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
│ • Owner Preferred   │
└─────────────────────┘
          ▲
          │ Uploads via CLI/SDK
┌─────────────────────┐
│ Your Applications   │
└─────────────────────┘
```

## 🛠️ Prerequisites

```bash
# 1. Verify EXACT versions (AIG standard)
terraform version  # Terraform v1.9.4
aws --version

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
cd Terraform-30-projects/beginner/02-s3-bucket-with-versioning

# Deploy with exact versions
terraform init
terraform plan -var="bucket_name=tf-project2-$(date +%s)"
terraform apply -var="bucket_name=tf-project2-$(date +%s)"

# Test uploads
aws s3 cp test.txt s3://$(terraform output bucket_name)/
aws s3 cp test.txt s3://$(terraform output bucket_name)/ --website

# Visit website
open $(terraform output website_url)
```

## 📁 File Structure

```
02-s3-bucket-with-versioning/
├── versions.tf          # Terraform 1.9.4 + AWS 5.70.1 (EXACT)
├── main.tf              # Complete S3 configuration
├── variables.tf         # Customizable settings
├── outputs.tf           # Bucket URLs and names
├── terraform.tfvars     # Default values
├── test-files/          # Sample files to upload
├── README.md
└── .gitignore
```

## 📝 Complete Code

### **versions.tf** (EXACT Enterprise Versions)
```hcl
terraform {
  required_version = "1.9.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"     # Confirmed available for Terraform 1.9.x
    }
  }
}

```

### **main.tf** (Production-Ready)
```hcl
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

# Ownership Controls (5.70.1 requirement)
resource "aws_s3_bucket_ownership_controls" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Public Access Settings (Website Compatible)
resource "aws_s3_bucket_public_access_block" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id
  
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
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
    id     = "production-lifecycle"
    status = "Enabled"
    
    filter {
      prefix = ""
    }
    
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
        Resource  = "${aws_s3_bucket.project_bucket.arn}/*"
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
Q1: Why Terraform 1.9.4 + AWS 5.70.1 specifically?
A: AIG financial standard - stable, compliance certified, full S3 v2 support.

Q2: Why separate versioning resource?
A: AWS provider 5.x requires separate resources vs legacy single-block.

Q3: Lifecycle filter block purpose?
A: 5.70.1+ requirement - empty prefix = all objects.
```

### **Intermediate Level**
```
Q4: Public access block settings?
A: false,false,true,false = allows website policy but blocks other public access.

Q5: SSE-S3 vs SSE-KMS cost?
A: SSE-S3 free (AWS keys). SSE-KMS $1 per 10k API calls.

Q6: Versioning compliance benefit?
A: Recover deletes, audit trail, regulatory requirements (SOX, GDPR).
```

### **Advanced Level**
```
Q7: Migration from ACL to ownership controls?
A: Remove acl="private", add aws_s3_bucket_ownership_controls.

Q8: Cross-account replication?
A: aws_s3_bucket_replication_configuration + bucket policy.

Q9: Terraform lockfile (.terraform.lock.hcl)?
A: Locks exact 5.70.1 version across team deployments.
```

## 🧪 Testing Your Deployment

```bash
# Variables
BUCKET=$(terraform output -raw bucket_name)
WEBSITE=$(terraform output -raw website_url)

# Upload test files
echo "<h1>Terraform Project 2 - 1.9.4 + 5.70.1 Success!</h1>" > index.html
aws s3 cp index.html s3://$BUCKET/

# Test versioning (upload same file twice)
echo "Version 1" > test.txt
aws s3 cp test.txt s3://$BUCKET/
echo "Version 2" > test.txt  
aws s3 cp test.txt s3://$BUCKET/

# Verify website
curl $WEBSITE
open $WEBSITE

# List versions
aws s3api list-object-versions --bucket $BUCKET
```

**Expected Results:**
```
$ curl http://tf-project2-abc123.s3-website-us-east-1.amazonaws.com
<h1>Terraform Project 2 - 1.9.4 + 5.70.1 Success!</h1>
```

## ⚠️ Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `Bucket name taken` | Global collision | `bucket_name=tf-project2-$(date +%s)` |
| `Access denied` | Public block conflict | Check `aws_s3_bucket_public_access_block` settings |
| `Lifecycle filter error` | Missing filter block | Add `filter { prefix = "" }` |
| `Policy malformed` | JSON syntax | Verify `Resource` (singular) in policy |
| `Versioning disabled` | State drift | `terraform apply` |

## 🧹 Clean Up

```bash
# Destroy (empties bucket first)
terraform destroy -auto-approve -var="bucket_name=$BUCKET"

# Manual cleanup if needed
aws s3 rb s3://$BUCKET --force
```

## 🎓 Next Steps

1. **[Project 3]** VPC + Public Subnet (Networking)
2. **Advanced:** CloudFront CDN + Lambda@Edge
3. **Expert:** Multi-region replication + EventBridge

## 📄 License
MIT License - Free for learning/portfolio

***

**⭐ Star:** https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects  
**🐛 Issues:** [Create Issue](https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects/issues/new)

*Updated: Jan 2026 | Terraform 1.9.4 | AWS 5.70.1*

[1](https://docs.cloud.google.com/docs/terraform/best-practices/general-style-structure)
[2](https://alexwlchan.net/2023/terraform-template-docs/)
[3](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
[4](https://devopstar.com/2024/04/17/a-pretty-good-terraform-module-template/)
[5](https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html)
[6](https://discuss.hashicorp.com/t/readme-md-for-terraform-module/58748)
[7](https://github.com/cloudposse/terraform-example-module/blob/main/README.md)
[8](https://code.vt.edu/devcom/terraform-modules/guidelines/-/blob/master/sample-readme.md)
[9](https://spacelift.io/blog/terraform-files)
[10](https://www.youtube.com/watch?v=QMsJholPkDY)

