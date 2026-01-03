
# Terraform Project 3: VPC with Public Subnet

[
[

## 🎯 Project Overview

**Level:** Beginner (Project #3/30)  
**Estimated Time:** 25 minutes  
**Cost:** **Free** (VPC networking has no cost)  
**Real-World Use Case:** Foundation for all AWS infrastructure, multi-tier apps, isolation

This project creates a **complete VPC networking stack** with:
- Custom VPC (CIDR 10.0.0.0/16)
- Public subnet across 2 AZs
- Internet Gateway + Route Table
- NACLs (Network ACLs)
- Proper tagging and outputs

## 📋 Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [File Structure](#file-structure)
- [Complete Code](#complete-code)
- [Real-time Interview Questions](#real-time-interview-questions)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Clean Up](#clean-up)

## ✨ Features

| Feature | Implemented | Terraform Resource |
|---------|-------------|-------------------|
| Custom VPC | ✅ | `aws_vpc` |
| Public Subnets (2 AZs) | ✅ | `aws_subnet` |
| Internet Gateway | ✅ | `aws_internet_gateway` |
| Route Table | ✅ | `aws_route_table` |
| NACLs | ✅ | `aws_network_acl` |
| Auto-scaling tags | ✅ | `tags` |

## 🏗️ Architecture

```
┌─────────────────┐
│   Internet      │◄────[0.0.0.0/0]──── Public Subnets
│                 │
└─────────┬───────┘
          │
     ┌────▼────┐
     │Internet │
     │Gateway  │
     └────┬────┘
          │
┌─────────────────┐
│   Custom VPC    │ 10.0.0.0/16
│                 │
│ ┌───────────┐ ┌───────────┐
│ │Public AZ1 │ │Public AZ2 │
│ │10.0.1.0/24│ │10.0.2.0/24│
│ └───────────┘ └───────────┘
└─────────────────┘
```

## 🛠️ Prerequisites

```bash
# 1. Terraform >= 1.5.0
terraform version

# 2. AWS CLI with EC2/VPCFullAccess
aws ec2 describe-vpcs

# 3. IAM Permissions
- ec2:CreateVpc, CreateSubnet, CreateInternetGateway
- ec2:CreateRoute, CreateRouteTable, AssociateRouteTable
```

## 🚀 Quick Start

```bash
# Navigate to project
cd Terraform-30-projects/projects/beginner/03-vpc-public-subnet

# Deploy networking foundation
terraform init
terraform plan
terraform apply

# Verify outputs
terraform output vpc_id
terraform output public_subnet_ids
```

## 📁 File Structure

```
03-vpc-public-subnet/
├── main.tf              # VPC + networking resources
├── variables.tf         # CIDR blocks, AZs
├── outputs.tf           # VPC IDs, subnet lists
├── terraform.tfvars     # Regional defaults
├── README.md
└── .gitignore
```

## 📝 Complete Code

### **main.tf** (Production-Ready VPC)
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

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Custom VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.default_tags, {
    Name = "${var.environment}-vpc-${var.project_name}"
  })
}

# Public Subnet 1 (AZ1)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.default_tags, {
    Name = "${var.environment}-public-1"
    Type = "Public"
  })
}

# Public Subnet 2 (AZ2)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(var.default_tags, {
    Name = "${var.environment}-public-2"
    Type = "Public"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name = "${var.environment}-igw"
  })
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.default_tags, {
    Name = "${var.environment}-public-rt"
  })
}

# Route Table Association (Public Subnet 1)
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Route Table Association (Public Subnet 2)
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Network ACL for Public Subnets
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  egress {
    rule_no     = 100
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  ingress {
    rule_no     = 100
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = merge(var.default_tags, {
    Name = "${var.environment}-public-nacl"
  })
}
```

### **variables.tf**
```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project identifier"
  type        = string
  default     = "terraform-30-projects"
}

variable "default_tags" {
  description = "Default resource tags"
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
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "public_subnets" {
  description = "Public subnet details"
  value = {
    subnet1 = {
      id   = aws_subnet.public_1.id
      az   = aws_subnet.public_1.availability_zone
      cidr = aws_subnet.public_1.cidr_block
    }
    subnet2 = {
      id   = aws_subnet.public_2.id
      az   = aws_subnet.public_2.availability_zone
      cidr = aws_subnet.public_2.cidr_block
    }
  }
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}
```

## 💬 Real-time Interview Questions

### **Beginner Level**
```
Q1: Why map_public_ip_on_launch = true?
A: Auto-assigns public IP to instances launched in subnet.

Q2: VPC vs Default VPC differences?
A: Custom VPC = full control. Default = AWS managed with defaults.

Q3: Route table vs NACL vs SG?
A: Route=where traffic goes, NACL=stateless firewall, SG=stateful security.
```

### **Intermediate Level**
```
Q4: Why 2 public subnets in different AZs?
A: High availability. ALB/ASG span multiple AZs.

Q5: CIDR 10.0.0.0/16 → how many /24 subnets?
A: 256 subnets (10.0.0.0/24 to 10.0.255.0/24).

Q6: Route table propagation?
A: Manual association required for custom route tables.
```

### **Advanced Level**
```
Q7: Add private subnets + NAT Gateway?
A: 10.0.3.0/24, 10.0.4.0/24 + aws_nat_gateway + private RT.

Q8: VPC Flow Logs for monitoring?
A: aws_flow_log + CloudWatch Log Group.

Q9: VPC Endpoint for private services?
A: aws_vpc_endpoint (S3, DynamoDB) to avoid IGW.
```

## 🧪 Testing Your Deployment

```bash
# Store outputs
VPC_ID=$(terraform output -raw vpc_id)
SUBNET1=$(terraform output -raw public_subnet_ids | jq -r '.[0]')

# Verify VPC
aws ec2 describe-vpcs --vpc-ids $VPC_ID

# Check subnets have public IPs
aws ec2 describe-subnets --subnet-ids $SUBNET1

# Test launch EC2 in VPC (uses Project 1)
terraform output public_subnet_ids
```

**Expected Results:**
```
$ aws ec2 describe-subnets --subnet-ids subnet-xxx
"MapPublicIpOnLaunch": true
```

## ⚠️ Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `Overlapping CIDR` | CIDR conflict | Change `vpc_cidr = "10.1.0.0/16"` |
| `No AZs found` | Region issue | Set `region = "us-east-1"` |
| `Route not propagating` | Missing assoc | Check `aws_route_table_association` |
| `Subnet not public` | No IGW route | Verify `0.0.0.0/0 → igw-xxx` |

## 🧹 Clean Up

```bash
terraform destroy -auto-approve

# Verify cleanup
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=Terraform-30-Projects"
```

## 🎓 Next Steps

1. **[Project 4]** RDS Database Instance
2. **Learn:** `for_each` for subnets, VPC peering
3. **Practice:** Deploy EC2 from Project 1 into this VPC
4. **Advanced:** Add private subnets + NAT Gateway

## 📄 License
MIT License - Free for learning/portfolio

***

**⭐ Star: https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects**  
**🐛 Issues: [Create Issue](https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects/issues/new)**

*Updated: Jan 2026* 




