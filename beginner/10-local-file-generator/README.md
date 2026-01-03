
# Terraform Project 10: Local File Generator

[
[

## 🎯 Project Overview

**Level:** Beginner (Project #10/30)  
**Estimated Time:** 15 minutes  
**Cost:** **$0.00** (100% Free - No cloud)  
**Real-World Use Case:** Config generation, CI/CD pipelines, module development, testing

This project demonstrates **Terraform's local provider** capabilities by:
- Generating **multiple config files** (nginx, app, database)
- Creating **directory structure** for applications
- **Dynamic templating** with variables and `templatefile()`
- **JSON/YAML** configuration generation
- **File validation** and checksums
- Perfect for **module testing** and **local development**

## 📋 Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [File Structure](#file-structure)
- [Complete Code](#complete-code)
- [Industry Best Practices](#industry-best-practices)
- [Real-time Interview Questions](#real-time-interview-questions)
- [Testing](#testing)
- [Use Cases](#use-cases)

## ✨ Features

| Feature | Implemented | Terraform Resource |
|---------|-------------|-------------------|
| **Config Files** | ✅ | `local_file` |
| **Directory Structure** | ✅ | `local_file` + directories |
| **Template Processing** | ✅ | `templatefile()` |
| **JSON/YAML Output** | ✅ | `yamlencode()`, `jsonencode()` |
| **File Validation** | ✅ | `lifecycle` + checksums |
| **Dynamic Content** | ✅ | `for_each`, variables |
| **Sensitive Data** | ✅ | `sensitive = true` |

## 🏗️ Architecture *(Local Only)*

```
📁 generated-configs/
├── nginx/
│   ├── nginx.conf
│   └── sites-available/default
├── app/
│   ├── config.json
│   ├── config.yaml
│   └── database.env
├── infra/
│   ├── terraform.tfvars
│   └── providers.tf
└── logs/
    └── application.log
```

## 🛠️ Prerequisites

```bash
# 1. Terraform only (no cloud auth needed)
terraform version

# 2. Working directory with write permissions
mkdir -p terraform-30-projects/projects/beginner/10-local-file-generator
cd terraform-30-projects/projects/beginner/10-local-file-generator

# 3. Optional: yq, jq for validation
sudo snap install yq jq  # Ubuntu
```

## 🚀 Quick Start

```bash
# Navigate to project
cd Terraform-30-projects/projects/beginner/10-local-file-generator

# Generate all configs instantly
terraform init
terraform apply

# Verify generated files
ls -la generated-configs/
cat generated-configs/nginx/nginx.conf
```

## 📁 File Structure

```
10-local-file-generator/
├── main.tf              # All local_file resources
├── variables.tf         # App configuration
├── outputs.tf           # File paths, content previews
├── templates/           # Jinja2-style templates
│   ├── nginx.conf.tpl
│   └── app-config.json.tpl
├── versions.tf
├── generated-configs/   # OUTPUT: Generated files
├── README.md
└── .gitignore
```

## 💻 Complete Code *(Production Ready)*

### **versions.tf**
```hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
```

### **variables.tf**
```hcl
variable "app_name" {
  description = "Application name"
  type        = string
  default     = "terraform-app"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "nginx_config" {
  description = "Nginx server configuration"
  type = object({
    port      = number
    workers   = number
    timeout   = number
    ssl       = bool
  })
  default = {
    port    = 8080
    workers = 4
    timeout = 30
    ssl     = false
  }
}

variable "database_config" {
  description = "Database connection settings"
  type = object({
    host     = string
    port     = number
    name     = string
    username = string
  })
  default = {
    host     = "localhost"
    port     = 5432
    name     = "app_db"
    username = "app_user"
  }
}
```

### **main.tf** *(Complete File Generation)*
```hcl
provider "local" {}

provider "template" {}

# Ensure output directory exists
resource "null_resource" "create_dirs" {
  provisioner "local-exec" {
    command = "mkdir -p generated-configs/{nginx,app,infra,logs}"
  }
}

# Dynamic nginx configuration
resource "local_file" "nginx_conf" {
  depends_on  = [null_resource.create_dirs]
  content     = templatefile("${path.module}/templates/nginx.conf.tpl", {
    app_name    = var.app_name
    environment = var.environment
    config      = var.nginx_config
  })
  filename    = "${path.module}/generated-configs/nginx/nginx.conf"
}

# Application JSON config
resource "local_file" "app_json" {
  depends_on  = [null_resource.create_dirs]
  content     = jsonencode({
    name        = var.app_name
    environment = var.environment
    version     = "1.0.0"
    database    = var.database_config
    debug       = var.environment == "dev" ? true : false
    ports = {
      http  = var.nginx_config.port
      https = var.nginx_config.ssl ? 8443 : null
    }
  })
  filename    = "${path.module}/generated-configs/app/config.json"
}

# Application YAML config
resource "local_file" "app_yaml" {
  depends_on  = [null_resource.create_dirs]
  content     = yamlencode({
    app_name    = var.app_name
    environment = var.environment
    database    = var.database_config
    nginx = {
      port    = var.nginx_config.port
      workers = var.nginx_config.workers
    }
  })
  filename    = "${path.module}/generated-configs/app/config.yaml"
}

# Database environment file (.env)
resource "local_file" "db_env" {
  depends_on  = [null_resource.create_dirs]
  sensitive_content = true
  content     = templatefile("${path.module}/templates/db.env.tpl", var.database_config)
  filename    = "${path.module}/generated-configs/app/database.env"
}

# Terraform tfvars for other projects
resource "local_file" "terraform_vars" {
  depends_on  = [null_resource.create_dirs]
  content     = templatefile("${path.module}/templates/terraform.tfvars.tpl", {
    app_name = var.app_name
    env      = var.environment
  })
  filename    = "${path.module}/generated-configs/infra/terraform.tfvars"
}

# Sample log file structure
resource "local_file" "log_file" {
  depends_on  = [null_resource.create_dirs]
  content     = "[${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}] ${var.app_name} started in ${var.environment} mode\n"
  filename    = "${path.module}/generated-configs/logs/application.log"
}
```

### **templates/nginx.conf.tpl**
```nginx
# Generated by Terraform Project 10
user nginx;
worker_processes ${config.workers};

error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # App-specific configuration
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    keepalive_timeout ${config.timeout};
    client_max_body_size 32m;

    server {
        listen ${config.port};
        server_name ${app_name}-${environment}.local;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
            try_files $uri $uri/ =404;
        }

        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
```

### **outputs.tf**
```hcl
output "generated_files" {
  description = "All generated configuration files"
  value = {
    nginx_conf  = "${path.module}/generated-configs/nginx/nginx.conf"
    app_json    = "${path.module}/generated-configs/app/config.json"
    app_yaml    = "${path.module}/generated-configs/app/config.yaml"
    db_env      = "${path.module}/generated-configs/app/database.env"
    terraform_vars = "${path.module}/generated-configs/infra/terraform.tfvars"
    log_file    = "${path.module}/generated-configs/logs/application.log"
  }
}

output "file_preview" {
  description = "Preview of nginx.conf (first 200 chars)"
  value       = substr(local_file.nginx_conf.content, 0, 200)
}

output "json_config_preview" {
  description = "JSON config structure"
  value       = jsondecode(local_file.app_json.content)
}
```

## 🏆 Industry Best Practices Applied

| Practice | Implemented | Why Important |
|----------|-------------|--------------|
| ✅ **Directory Creation** | `null_resource` + `local-exec` | Predictable structure |
| ✅ **Template Processing** | `templatefile()` | Dynamic + reusable |
| ✅ **Sensitive Content** | `sensitive_content = true` | Secrets protection |
| ✅ **Multiple Formats** | JSON/YAML/ENV/HCL | Tooling compatibility |
| ✅ **Validation Ready** | Structured data | Schema validation |

## 💬 Real-time Interview Questions

### **🔥 Local Provider Mastery**
```
Q1: When to use local_file vs external data source?
A: local_file = generate files. external = read external data.

Q2: templatefile() vs heredoc (<<EOF)?
A: templatefile = variables + loops + conditionals. heredoc = static content.

Q3: How to validate generated JSON/YAML?
A: Use yamllint, jq, or terraform validate in CI pipeline.
```

### **🎯 CI/CD Integration**
```
Q4: Generate Kubernetes manifests?
A: templatefile("deployment.tpl", { replicas = var.replicas }) → kubectl apply.

Q5: Safe for production config generation?
A: No. Use for dev/CI only. Prod = config management (Puppet/Ansible).
```

## 🧪 Testing Your Deployment

```bash
# Verify all files created
terraform output generated_files

# Validate configurations
cat generated-configs/nginx/nginx.conf | head -20
jq . generated-configs/app/config.json
yq e . generated-configs/app/config.yaml

# Test nginx config syntax
docker run --rm -v $(pwd)/generated-configs/nginx:/etc/nginx nginx nginx -t -c /etc/nginx/nginx.conf

# Word count stats
find generated-configs -type f -exec wc -l {} + | tail -5
```

**Expected Results:**
```
$ jq . generated-configs/app/config.json
{
  "name": "terraform-app",
  "environment": "dev",
  "database": {
    "host": "localhost",
    "port": 5432,
    ...
  }
}
```

## ⚠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| `Permission denied` | `chmod 755 generated-configs/` |
| `Template not found` | Verify `templates/` directory |
| `Invalid YAML/JSON` | Check `yamlencode()`, `jsonencode()` |
| `Files not updating` | `terraform taint local_file.nginx_conf` |

## 🧪 Use Cases

```
✅ Module development (generate test configs)
✅ CI/CD pipeline configs (docker-compose, k8s manifests)
✅ Local development environments
✅ Documentation generation
✅ Terraform module testing
✅ Config validation pipelines
❌ Production configuration (use CM tools)
```

## 🧹 Clean Up

```bash
# Delete generated files
rm -rf generated-configs/

# Or let terraform destroy handle it
terraform destroy
```

## 🎓 Next Steps

1. **[Project 11]** Multi-Tier VPC (AWS) - **Intermediate**
2. **Learn:** `for_each` with local_file, external data sources
3. **Practice:** Generate Kubernetes manifests
4. **Advanced:** GitOps config generation + validation

## 📄 License
MIT License - Free for learning/portfolio

***

**⭐ Star: https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects**  
**🧪 Test: `terraform apply && ls generated-configs/`**

*Updated: Jan 2026* ✅ 




