
 # 🟢 Terraform Beginner Projects (1-10)- Complete Learning Path

[![Beginner](https://img.shields.io/badge/Level-Beginner-00D4AA?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTUyIiBoZWlnaHQ9IjE2MCIgdmlld0JveD0iMCAwIDE1MiAxNjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIxNTIiIGhlaWdodD0iMTYwIiBmaWxsPSIjMDBENEFBIi8+CjxwYXRoIGQ9Ik0xNCAxNDBIMTUyVjE2MEgxNFYxNDBaIiBmaWxsPSIjMDBCRTkiLz4KPC9zdmc+)](../)
[![Projects](https://img.shields.io/badge/Projects-10%2F30-4CAF50?style=for-the-badge&logo=gitbook&logoColor=white)](../)
[![Cost](https://img.shields.io/badge/Total_Cost-%240.10-00D4AA?style=for-the-badge&logo=money-off&logoColor=white)](../)
[![Time](https://img.shields.io/badge/Total_Time-4.5hrs-2196F3?style=for-the-badge&logo=clock&logoColor=white)](../)

## 📁 Available Projects
| # | Project | Status |
|---|---------|--------|
[![Project-1](https://img.shields.io/badge/P1-✅-00D4AA?style=flat-square)](01-single-ec2-instance-on-aws/) | EC2 Instance | Ready |
[![Project-2](https://img.shields.io/badge/P2-✅-00D4AA?style=flat-square)](02-s3-bucket-versioning/) | S3 Versioning | Ready |
...


## 🎯 **Beginner Projects Overview**

**Total Projects:** 10 | **Level:** 🟢 **Beginner** | **Total Time:** ~4.5 hours | **Cloud Cost:** ~$0.10 total (mostly free tier)

Welcome to **Terraform Beginner Projects (1-10)**! These projects teach **Terraform core concepts** through **real-world examples** across **5 cloud providers** (AWS, Azure, GCP, DigitalOcean, Local). Each project builds progressively, introducing new concepts while reinforcing previous learning.

***

## 📋 **Table of Contents**
- [Learning Objectives](#learning-objectives)
- [Core Terraform Concepts](#core-terraform-concepts)
- [Project-by-Project Breakdown](#project-by-project-breakdown)
- [Prerequisites](#prerequisites)
- [Progressive Learning Path](#progressive-learning-path)
- [Cloud Cost Summary](#cloud-cost-summary)
- [Troubleshooting Guide](#troubleshooting-guide)

## 🎓 **Learning Objectives**

| Skill | Projects | Key Takeaway |
|-------|----------|--------------|
| **Resource Creation** | 1-10 | `aws_instance`, `azurerm_linux_virtual_machine`, `google_compute_instance` |
| **Networking** | 3,8,9 | VPC, VNet, Firewall rules, NSG |
| **Configuration Management** | 1,4-10 | `user_data`, `cloud-init`, `startup_script`, `local_file` |
| **Security** | All | Security Groups, IAM roles, SSH keys, encryption |
| **Multi-Provider** | 7-10 | AWS → Azure → GCP → DigitalOcean → Local |
| **Data Sources** | 1,4,9 | Dynamic AMI, AZ discovery, external data |

## 🔧 **Core Terraform Concepts** (Progressive)

### **Level 1: Basic Resources** *(Projects 1-2)*
```
resource "aws_instance" "web" { ... }           # Single resource
resource "aws_s3_bucket" "bucket" { ... }        # Provider syntax
```

### **Level 2: Dependencies** *(Projects 3-6)*
```
vpc_security_group_ids = [aws_security_group.main.id]  # Implicit dependency
depends_on = [aws_security_group.main]                 # Explicit dependency
```

### **Level 3: Data Sources** *(Projects 1,4,9)*
```
data "aws_ami" "amazon_linux" { ... }  # Dynamic data lookup
data "aws_availability_zones" "available" { ... }
```

### **Level 4: Variables + Outputs** *(All)*
```
variable "instance_type" { default = "t3.micro" }     # Input variables
output "public_ip" { value = aws_instance.web.public_ip }  # Return values
```

### **Level 5: Multi-Provider** *(Projects 7-10)*
```
provider "aws" { region = "us-east-1" }
provider "azurerm" { features {} }
provider "google" { project = var.project_id }
```

***

## 📁 **Project-by-Project Breakdown**

| # | Project | Cloud | **Core Concepts** | **Time** | **Cost** | **Key Resources** |
|---|---------|-------|-------------------|----------|----------|-------------------|
| **1** | **Single EC2 Instance** | AWS | `resource`, `variables`, `user_data` | 30m | $0.02/hr | `aws_instance`, `aws_security_group` |
| **2** | **S3 Bucket Versioning** | AWS | `separate_resources`, `jsonencode()` | 20m | **Free** | `aws_s3_bucket_versioning`, `aws_s3_bucket_policy` |
| **3** | **VPC + Public Subnets** | AWS | **Dependencies**, `data "aws_availability_zones"` | 25m | **Free** | `aws_vpc`, `aws_subnet`, `aws_internet_gateway` |
| **4** | **RDS MySQL Multi-AZ** | AWS | **Data sources**, `random_password`, `db_subnet_group` | 35m | $0.025/hr | `aws_db_instance`, `aws_db_subnet_group` |
| **5** | **Static Website + CloudFront** | AWS | **Complex resources**, `aws_cloudfront_origin_access_identity` | 30m | $0.01/mo | `aws_cloudfront_distribution`, OAI |
| **6** | **Lambda + API Gateway** | AWS | **Multiple integrations**, IAM roles, CORS | 40m | $0.001/1M | `aws_lambda_function`, `aws_api_gateway_rest_api` |
| **7** | **Discourse on DigitalOcean** | **DigitalOcean** | **Multi-provider**, `digitalocean_droplet` | 25m | $6/mo | `digitalocean_droplet`, `digitalocean_database_cluster` |
| **8** | **Azure Linux VM** | **Azure** | `azurerm_*`, `cloud-init`, **Resource Groups** | 30m | $0.015/hr | `azurerm_linux_virtual_machine`, VNet, NSG |
| **9** | **GCP Compute Instance** | **GCP** | `google_*`, **Service Accounts**, OS Login | 25m | **Free** | `google_compute_instance`, VPC firewall |
| **10** | **Local File Generator** | **Local** | **`local_file`**, `templatefile()`, `yamlencode()`** | 15m | **$0** | `local_file`, `null_resource` |

***

## 🛠️ **Prerequisites** (One-time Setup)

### **1. Install Terraform** (~5 minutes)
```bash
# Ubuntu/Debian
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# macOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### **2. Cloud CLI Setup** (~15 minutes total)
```bash
# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# GCP CLI
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# DigitalOcean CLI
curl -sL https://cli.digitalocean.com/install.sh | sudo python3
```

### **3. Authentication** (Per Cloud)
```bash
# AWS
aws configure

# Azure
az login

# GCP
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# DigitalOcean
export DIGITALOCEAN_TOKEN="your-api-token"
```

***

## 🚀 **Progressive Learning Path**

```
Week 1: AWS Fundamentals (Projects 1-3)
  → Basic resources → Networking → Data sources

Week 2: AWS Advanced (Projects 4-6)  
  → Databases → CDN → Serverless APIs

Week 3: Multi-Cloud (Projects 7-10)
  → DigitalOcean → Azure → GCP → Local provider

Week 4: Review + Combine
  → Deploy full-stack app using projects 1+3+4
```

### **Daily Schedule** (2-3 projects/day)
```
Day 1: Projects 1-2 (EC2 + S3) → 50m
Day 2: Projects 3-4 (VPC + RDS) → 60m  
Day 3: Projects 5-6 (CDN + Lambda) → 70m
Day 4: Projects 7-8 (DO + Azure) → 55m
Day 5: Projects 9-10 (GCP + Local) → 40m
```

***

## 💰 **Cloud Cost Summary**

| Project | Monthly Cost | Free Tier Eligible | Notes |
|---------|--------------|--------------------|-------|
| **1. EC2** | $15 (t3.micro) | ✅ | Stop when not using |
| **2. S3** | **$0** | ✅ | Always free tier |
| **3. VPC** | **$0** | ✅ | Networking free |
| **4. RDS** | $18 (db.t3.micro) | ✅ 750hrs/month | Multi-AZ adds cost |
| **5. CloudFront** | **$0.01** | ✅ 1TB/month | Minimal usage |
| **6. Lambda** | **$0** | ✅ 1M requests free | Serverless |
| **7. Discourse** | **$18** | ❌ | DO droplets + DB |
| **8. Azure VM** | $15 (B2s) | ✅ | Stop when not using |
| **9. GCP VM** | **$0** | ✅ Always Free e2-micro | US regions only |
| **10. Local** | **$0** | ✅ | No cloud |

**Total for 1 month active learning: ~$65** (destroy resources daily to save 90%)

***

## 🔍 **Core Terraform Concepts by Project**

### **Project 1: Single EC2** - **Foundation**
```
✅ resource "aws_instance" {} - First resource ever
✅ vpc_security_group_ids = [resource.id] - Implicit dependency  
✅ user_data = <<-EOF - Multi-line scripts
✅ output "public_ip" {} - Return computed values
```

### **Project 2: S3 Versioning** - **Configuration**
```
✅ Multiple aws_s3_bucket_* resources - Sub-resources
✅ jsonencode() - Policy documents
✅ lifecycle rules - Cost optimization
```

### **Project 3: VPC Networking** - **Dependencies**
```
✅ data "aws_availability_zones" {} - Dynamic data
✅ aws_route_table_association - Explicit associations
✅ for_each patterns preparation
```

### **Project 10: Local Files** - **Meta-Programming**
```
✅ local_file + templatefile() - Dynamic config generation
✅ yamlencode(), jsonencode() - Structured data
✅ null_resource - Directory management
```

***

## 🧪 **Standard Workflow** (Every Project)

```bash
# 1. Navigate + Init
cd projects/beginner/XX-project-name
terraform init

# 2. Plan (always check!)
terraform plan

# 3. Deploy
terraform apply

# 4. Test (curl/ssh/website)
curl $(terraform output endpoint)

# 5. Clean up (CRITICAL!)
terraform destroy
```

## 🚨 **Troubleshooting Guide**

| Issue | Symptoms | Fix |
|-------|----------|-----|
| **Auth errors** | `AccessDenied`, `Unauthorized` | `aws configure`, `az login`, `gcloud auth` |
| **Resource conflicts** | `already exists` | `terraform destroy`, random suffix |
| **Provider version** | `version conflict` | Check `versions.tf` |
| **SSH timeout** | Connection refused | Security Groups (port 22), wait 2min |
| **Quota exceeded** | `LimitExceeded` | Request quota increase |

## 🎯 **Success Metrics**

**Complete when you can:**
```
✅ [ ] Deploy EC2 + access via SSH (Project 1)
✅ [ ] Create VPC + launch VM inside (Project 3)
✅ [ ] Deploy full-stack (EC2 + RDS + S3) 
✅ [ ] Switch between AWS/Azure/GCP fluently
✅ [ ] Generate configs with local_file (Project 10)
✅ [ ] Answer "What's implicit dependency?"
✅ [ ] Explain data sources vs resources
✅ [ ] Destroy resources without fear
```

## 🎓 **Next Level: Intermediate (Projects 11-20)**

```
✅ Multi-tier VPC + NAT Gateway (11)
✅ EKS Kubernetes Cluster (12) 
✅ ECS Fargate + ALB (13)
✅ Multi-cloud databases (15)
✅ GitHub Actions integration (16)
```

***

## 🙌 **Why This Path Works**

1. **Progressive Complexity** - 1 resource → full-stack
2. **Multi-Cloud Exposure** - AWS(60%) + Azure(20%) + GCP(10%) + DO(10%)  
3. **Real Interview Projects** - Every project = resume bullet
4. **Cost Controlled** - 95% free tier usage
5. **Hands-on Priority** - 80% code, 20% theory

**Start with Project 1 → Deploy → SSH → Destroy → Repeat**

***

**⭐ Star if helpful!**  
**🐛 Issues: [Create Issue](https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects/issues/new)**  
**🎓 Ready for Intermediate? → `cd ../intermediate/`**

*Updated: Jan 2026* 




