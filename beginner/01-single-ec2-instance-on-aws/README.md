# Terraform Project 1: Single EC2 Instance on AWS

[
[

## 🎯 Project Overview

**Level:** Beginner (Project #1/30)  
**Estimated Time:** 30 minutes  
**Cost:** ~$0.02/hour (t3.micro)  
**Real-World Use Case:** Deploy development/test servers, bastion hosts, simple web servers

This project creates a **single AWS EC2 instance** with:
- Amazon Linux 2 AMI
- Security Group (SSH + HTTP access)
- User Data script (installs nginx)
- Proper tagging and output values

## 📋 Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [File Structure](#file-structure)
- [How It Works](#how-it-works)
- [Real-time Interview Questions](#real-time-interview-questions)
- [Troubleshooting](#troubleshooting)
- [Clean Up](#clean-up)

## ✨ Features

| Feature | Implemented | Terraform Resource |
|---------|-------------|-------------------|
| EC2 Instance | ✅ | `aws_instance` |
| Security Group | ✅ | `aws_security_group` |
| User Data Script | ✅ | `user_data` |
| Tags | ✅ | `tags` |
| Output Values | ✅ | `outputs.tf` |
| Variables | ✅ | `variables.tf` |

## 🏗️ Architecture

```mermaid
graph TD
    A[AWS VPC<br/>(Default)] --> B[Public Subnet]
    B --> C[EC2 Instance<br/>t3.micro<br/>Amazon Linux 2]
    B --> D[Security Group<br/>SSH:22<br/>HTTP:80]
    C --> E[Nginx<br/>via User Data]
```

## 🛠️ Prerequisites

```bash
# 1. Install Terraform (>= 1.5.0)
terraform version

# 2. Configure AWS CLI
aws configure

# 3. Required IAM Permissions
"""
EC2: CreateInstance, RunInstances, DescribeInstances
SecurityGroup: Create, AuthorizeIngress, Describe
"""
```

## 🚀 Quick Start

```bash
# Clone & Navigate
git clone https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects.git
cd projects/beginner/01-single-ec2-instance-on-aws

# Configure (optional)
cp terraform.tfvars.example terraform.tfvars
# Edit AWS region, instance_type if needed

# Deploy
terraform init
terraform plan
terraform apply

# Access your instance
terraform output public_ip
ssh -i key.pem ec2-user@<PUBLIC_IP>
```

## 📁 File Structure

```
project-1-ec2-instance/
├── main.tf          # Core infrastructure
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── terraform.tfvars.example  # Variable defaults
├── README.md        # This file!
└── .gitignore       # Terraform ignores
```

## 🔍 How It Works

### 1. **main.tf** - Core Resources

```hcl
# Security Group first (dependency)
resource "aws_security_group" "web_server" {
  name_prefix = "tf-project1-"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production!
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance (depends on SG)
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.web_server.id]
  
  # Install NGINX via user data
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "Terraform Project 1 - $(hostname)" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name        = "TF-Project1-WebServer"
    Project     = "Terraform-Learning"
    Environment = var.environment
  }
}
```

### 2. **Key Terraform Concepts Demonstrated**

| Concept | Usage |
|---------|-------|
| **Resource Dependencies** | `vpc_security_group_ids = [aws_security_group.web_server.id]` |
| **Data Sources** | `data.aws_ami.amazon_linux` (latest AMI) |
| **User Data** | Multi-line heredoc (`<<-EOF`) |
| **Variables** | `var.instance_type`, `var.environment` |
| **Outputs** | Instance IP, DNS, state |

## 💬 Real-time Interview Questions

### **Beginner Level**
```
Q1: What's the difference between `aws_instance` and `aws_launch_template`?
A: aws_instance = single instance. aws_launch_template = template for ASG/scaling.

Q2: Why use data source for AMI instead of hardcoding?
A: Data sources fetch dynamic values. Latest AMI ID changes over time.

Q3: What's implicit dependency vs explicit?
A: Implicit: reference in argument. Explicit: `depends_on` meta-argument.
```

### **Intermediate Level**
```
Q4: How would you make this HA (2+ instances across AZs)?
A: Use ASG + Launch Template + Multi-AZ subnets + ELB.

Q5: Security concern with this SG? How to fix?
A: 0.0.0.0/0 too open. Fix: Use `var.my_ip = "YOUR_IP/32"` or VPC endpoints.

Q6: How does `terraform plan` know what changed?
A: Compares real infra (state file) vs desired config.
```

### **Advanced Level**
```
Q7: How to make this multi-environment (dev/stage/prod)?
A: Workspaces OR directory structure with tfvars files.

Q8: What's wrong with user_data in this example for production?
A: No error handling, no health checks, yum not idempotent.

Q9: How to convert to module?
A: Move to modules/ec2-single/, use module block with variables.
```

## 🧪 Testing Your Deployment

```bash
# 1. Verify instance running
aws ec2 describe-instances --filters "Name=tag:Name,Values=TF-Project1-WebServer"

# 2. Test web server
curl http://<PUBLIC_IP>

# 3. SSH access
ssh -i ~/.ssh/id_rsa ec2-user@<PUBLIC_IP>
sudo systemctl status nginx
```

**Expected Output:**
```
$ curl http://3.123.45.67
<h1>Terraform Project 1 - ip-172-31-10-123</h1>
```

## ⚠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| "AMI not found" | Check region matches `var.region` |
| "Insufficient permissions" | Add EC2FullAccess policy temporarily |
| "Instance not accessible" | Check SG rules, subnet public |
| "User data failed" | Check `/var/log/cloud-init-output.log` |

## 🧹 Clean Up (Destroy)

```bash
terraform destroy
# Type "yes" to confirm
```

**Cost Check:**
```bash
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output table
```

## 🎓 Next Steps

1. **Project 2:** Add S3 bucket with versioning
2. **Learn:** Variables validation, locals, data sources
3. **Practice:** Deploy in different regions
4. **Advanced:** Convert to reusable module

## 📄 License
MIT License - Free to use for learning/portfolio

***

**⭐ Star this repo if helpful!**  
**👉 Ready for [Project 2: S3 Bucket with Versioning](https://github.com/yourusername/terraform-projects/tree/main/projects/beginner/s3-bucket)**

*Last Updated: Jan 2026*
