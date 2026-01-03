# Terraform Project 1: Single EC2 Instance on AWS

[
[

## 🎯 Project Overview

**Level:** Beginner (Project #1/30)  
**Estimated Time:** 30 minutes  
**Cost:** ~$0.02/hour (t3.micro)  
**Real-World Use Case:** Deploy development/test servers, bastion hosts, simple web servers

This project creates a **single AWS EC2 instance** with:
- Amazon Linux 2 AMI (latest)
- Security Group (SSH + HTTP access) 
- User Data script (installs nginx)
- Proper tagging and output values

## 📋 Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [File Structure](#file-structure)
- [Complete Code](#complete-code)
- [How It Works](#how-it-works)
- [Real-time Interview Questions](#real-time-interview-questions)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Clean Up](#clean-up)

## ✨ Features

| Feature | Implemented | Terraform Resource |
|---------|-------------|-------------------|
| EC2 Instance | ✅ | `aws_instance` |
| Security Group | ✅ | `aws_security_group` |
| User Data Script | ✅ | `user_data` |
| Data Source (AMI) | ✅ | `data.aws_ami` |
| Tags | ✅ | `tags` |
| Output Values | ✅ | `output` blocks |

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐
│   Internet      │    │  Default VPC     │
│                 │    │  (Public Subnet) │
└─────────┬───────┘    └────────┬─────────┘
          │                     │
          │ SSH(22), HTTP(80)   │
          ▼                     ▼
    ┌──────────────┐    ┌──────────────┐
    │ Your Laptop  │────│ EC2 Instance │───[Nginx Web Server]
    │   (curl/ssh) │    │ t3.micro     │
    └──────────────┘    └──────────────┘
```

## 🛠️ Prerequisites

```bash
# 1. Install Terraform (>= 1.5.0)
terraform version

# 2. AWS CLI configured with admin access
aws sts get-caller-identity
aws configure

# 3. Required IAM Permissions
- EC2: CreateInstance, RunInstances, DescribeInstances
- EC2: CreateSecurityGroup, AuthorizeSecurityGroupIngress
```

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects.git
cd Terraform-30-projects/projects/beginner/01-single-ec2-instance-on-aws

# Configure variables (optional)
cp terraform.tfvars.example terraform.tfvars
# Edit: region = "us-east-1", instance_type = "t3.micro"

# Deploy infrastructure
terraform init
terraform plan
terraform apply

# Access your instance
terraform output public_ip
curl http://$(terraform output -raw public_ip)
```

## 📁 File Structure

```
01-single-ec2-instance-on-aws/
├── main.tf              # All resources + data sources
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values
├── terraform.tfvars.example  # Variable template
├── README.md           # This file
└── .gitignore
```

## 📝 Complete Code

### **main.tf** (Complete Working Version)
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

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group
resource "aws_security_group" "web_server" {
  name_prefix = "tf-project1-sg-"
  
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: Restrict to your IP in production
  }
  
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "TF-Project1-SG"
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_server.id]
  
  # Associate with default subnet (public)
  subnet_id = data.aws_subnet.default.id
  
  # User Data to install NGINX
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Terraform Project 1 - $(hostname -f)</h1><p>Deployed: $(date)</p>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name        = "TF-Project1-WebServer"
    Project     = "Terraform-30-Projects"
    Environment = var.environment
  }
}

# Data source for default subnet
data "aws_subnet" "default" {
  default_for_az = true
  availability_zone = "${var.aws_region}a"
}
```

### **variables.tf**
```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition     = contains(["t3.micro", "t3.small", "t2.micro"], var.instance_type)
    error_message = "Instance type must be t3.micro, t3.small, or t2.micro."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
```

### **outputs.tf**
```hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}
```

## 💬 Real-time Interview Questions

### **Beginner Level**
```
Q1: Why use data.aws_ami instead of hardcoding AMI ID?
A: AMIs change frequently. Data source always gets latest matching AMI.

Q2: What's the difference between implicit and explicit dependencies?
A: Implicit: Reference in resource (vpc_security_group_ids). 
   Explicit: depends_on meta-argument.

Q3: Why subnet_id = data.aws_subnet.default.id?
A: Ensures instance launches in public subnet with internet access.
```

### **Intermediate Level**
```
Q4: Security issue with this SG? Production fix?
A: 0.0.0.0/0 too permissive. Fix: variable "my_ip" = "${chomp(data.http.myip.response_body)}/32"

Q5: How does Terraform know instance needs public IP?
A: Default subnet has auto-assign-public-ip enabled.

Q6: What happens if you run terraform apply twice?
A: No changes. Terraform is idempotent - only applies differences.
```

### **Advanced Level**
```
Q7: Convert to module? What inputs/outputs?
A: module "ec2" { source = "../modules/ec2" 
    instance_type = var.instance_type
  }
  Outputs: public_ip, instance_id

Q8: User_data not idempotent. Production fix?
A: Use cloud-init, or check if nginx exists before install.

Q9: Remote state for team use?
A: backend "s3" { bucket = "my-tf-state" key = "project1/terraform.tfstate" }
```

## 🧪 Testing Your Deployment

```bash
# Get outputs
PUBLIC_IP=$(terraform output -raw instance_public_ip)

# Test web server
curl http://$PUBLIC_IP
# Expected: <h1>Terraform Project 1 - ip-xxx-xx-xx-xx.ec2.internal</h1>

# Verify instance via AWS CLI
aws ec2 describe-instances --instance-ids $(terraform output -raw instance_id)

# SSH test (create key pair first)
ssh -i my-key.pem ec2-user@$PUBLIC_IP
curl localhost
```

## ⚠️ Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `No subnet found` | Wrong AZ | Change `availability_zone = "${var.aws_region}b"` |
| `AMI not found` | Region mismatch | Set `region = "us-east-1"` |
| `Access denied` | IAM missing perms | Attach `AmazonEC2FullAccess` |
| `Instance not public` | Private subnet | Use `default_for_az = true` |
| `User data failed` | Syntax error | Check `/var/log/cloud-init-output.log` |

## 🧹 Clean Up

```bash
# Destroy everything
terraform destroy -auto-approve

# Verify cleanup
aws ec2 describe-instances --filters "Name=tag:Project,Values=Terraform-30-Projects"
```

## 🎓 Next Steps

1. **[Project 2]** S3 Bucket with versioning + lifecycle
2. **Learn:** Locals, for_each, modules
3. **Practice:** Deploy in eu-west-1 region
4. **Advanced:** Convert to reusable module

## 📄 License
MIT License - Free for learning/portfolio

***

**⭐ Star: https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects**  
**🐛 Issues: https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects/issues**


*Last Updated: Jan 2026*




