
# Terraform Projects - Beginner to Expert
*30 Real-World Terraform Projects with Documentation Links*

[![Terraform](https://img.shields.io/badge/Terraform-5C3EE8?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects)
[![License-MIT](https://img.shields.io/badge/License-MIT-brightgreen?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTUyIiBoZWlnaHQ9IjE2MCIgdmlld0JveD0iMCAwIDE1MiAxNjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIxNTIiIGhlaWdodD0iMTYwIiBmaWxsPSIjMEU3NjI0Ii8+CjxwYXRoIGQ9Ik0xNCAxNDBIMTUyVjE2MEgxNFYxNDBaIiBmaWxsPSIjRkZGRkZGIi8+Cjwvc3ZnPgo=)](https://github.com/Chinthaparthy-UmasankarReddy/Terraform-30-projects/blob/main/LICENSE)


## 📋 Table of Contents
- [Beginner Projects (1-10)](#beginner-projects-1-10)
- [Intermediate Projects (11-20)](#intermediate-projects-11-20)
- [Expert Projects (21-30)](#expert-projects-21-30)
- [Prerequisites](#prerequisites)
- [How to Use](#how-to-use)
- [Learning Path](#learning-path)

## Beginner Projects (1-10)

| **Index** | **Project Name** | **Description** | **Key Skills** | **Details** |
|-----------|------------------|-----------------|----------------|-------------|
| **1** | Single EC2 Instance on AWS | Provision a basic Linux VM with security group and user data. | Basic `aws_instance`, variables. | Use `ami`, `instance_type`, and `vpc_security_group_ids`. [AWS Instance Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| **2** | S3 Bucket with Versioning | Create a bucket, enable versioning, and add lifecycle policy. | `aws_s3_bucket`, outputs. | Enable `versioning_configuration` block and `lifecycle_rule`. [S3 Bucket Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| **3** | VPC with Public Subnet | Set up VPC, internet gateway, and one public subnet. | `aws_vpc`, networking basics. | Attach `aws_internet_gateway` and route table. [VPC Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) |
| **4** | RDS Database Instance | Deploy MySQL RDS with subnet group and backup config. | `aws_db_instance`, dependencies. | Specify `engine`, `allocated_storage`, and `db_subnet_group_name`. [RDS Instance Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) |
| **5** | Static Website on S3 | Bucket with public hosting, index.html, and CloudFront. | `aws_s3_bucket_website_configuration`. | Set `website` block and public ACL policy. [S3 Website Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) |
| **6** | Lambda Function | Simple Python Lambda with IAM role and trigger. | `aws_lambda_function`, serverless intro. | Zip code to `filename` and attach `role`. [Lambda Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) |
| **7** | Discourse on DigitalOcean | Deploy forum app droplet with SSH key. | Provider switch, `digitalocean_droplet`. | Use `image="discourse"` and `ssh_keys`. [DO Droplet Docs](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) |
| **8** | Azure VM Basics | Linux VM in resource group with NIC and NSG. | `azurerm_linux_virtual_machine`. | Link `network_interface_ids` and `admin_ssh_key`. [Azure VM Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) |
| **9** | GCP Compute Instance | VM with firewall rules and startup script. | `google_compute_instance`. | Set `boot_disk` and `metadata_startup_script`. [GCP Instance Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) |
| **10** | Local File Generator | Create config files locally for testing. | `local_file`, no cloud. | Write `content` or `content_base64`. [Local File Docs](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |

## Intermediate Projects (11-20)

| **Index** | **Project Name** | **Description** | **Key Skills** | **Details** |
|-----------|------------------|-----------------|----------------|-------------|
| **11** | Multi-Tier VPC (AWS) | VPC with public/private subnets, NAT, and bastion host. | `aws_nat_gateway`, modules intro. | Use `aws_subnet` for_each and `aws_eip` dependency. [NAT Gateway Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) |
| **12** | EKS Kubernetes Cluster | Basic EKS with node groups and VPC. | `aws_eks_cluster`, Kubernetes provider. | Enable `vpc_config` and `kubernetes_cluster`. [EKS Cluster Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) |
| **13** | ECS Fargate Service | Container service with ALB and task definition. | `aws_ecs_service`, Docker integration. | Define `aws_ecs_task_definition` with `container_definitions`. [ECS Service Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) |
| **14** | OpenStack Instances | Multiple VMs with floating IPs and security groups. | `openstack_compute_instance_v2`. | Assign `floating_ip` pool. [OpenStack Instance Docs](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) |
| **15** | Multi-Cloud DB | RDS on AWS + equivalent on Azure/GCP. | Multiple providers, data sources. | Alias providers and use data sources for cross-ref. [Multi-Provider Docs](https://developer.hashicorp.com/terraform/language/providers/requirements#multiple-providers) |
| **16** | GitHub Repo with Actions | Infra for repo + CI/CD workflow via Terraform. | `github_repository`, external data. | Set `visibility` and `template`. [GitHub Repo Docs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) |
| **17** | ELK Stack on EC2 | Elasticsearch, Logstash, Kibana across instances. | Autoscaling groups, user data scripts. | Use `aws_launch_template` for ASG. [Launch Template Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) |
| **18** | Azure AKS Cluster | Managed Kubernetes with add-ons and monitoring. | `azurerm_kubernetes_cluster`. | Configure `default_node_pool`. [AKS Cluster Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) |
| **19** | GCP GKE Autopilot | Serverless GKE with workloads and Istio. | `google_container_cluster`. | Set `enable_autopilot=true`. [GKE Cluster Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) |
| **20** | WordPress on Lightsail | Instance with DB, custom domain, SSL. | `aws_lightsail_instance`. | Bundle `blueprint_id` for WordPress. [Lightsail Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance) |

## Expert Projects (21-30)

| **Index** | **Project Name** | **Description** | **Key Skills** | **Details** |
|-----------|------------------|-----------------|----------------|-------------|
| **21** | Serverless App Deployment | API Gateway, Lambda, DynamoDB chain. | Provisioners, remote state. | Integrate `aws_api_gateway_integration`. [API Gateway Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) |
| **22** | Three-Tier App on EKS | Web/app/DB layers with Helm releases via Terraform. | `helm_release`, workspaces. | Use `helm` provider post-EKS. [Helm Release Docs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| **23** | Terragrunt Multi-Env | DRY configs for dev/stage/prod across clouds. | Terragrunt wrapper, s3 backend. | Use `terragrunt.hcl` with `remote_state`. [Terragrunt Docs](https://terragrunt.gruntwork.io/) |
| **24** | Hybrid Cloud Networking | AWS VPC peering to Azure VNet + on-prem sim. | Peering resources, dynamic blocks. | `aws_vpc_peering_connection` with accepter. [Peering Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) |
| **25** | CI/CD Pipeline (CodePipeline) | Full pipeline with approvals, blue-green deploys. | `aws_codepipeline`, integrations. | Stage `actions` with approvals. [CodePipeline Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) |
| **26** | Highly Available Django App | ASG, ALB, RDS multi-AZ, caching (ElastiCache). | Liveness probes, chaos engineering sim. | `target_group_health_check`. [ASG Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) |
| **27** | Kubernetes Federation | Multi-cluster K8s mgmt across AWS/GCP. | `kubernetes_federation`, custom providers. | Custom provider or `kubectl` provider. [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) |
| **28** | Game Server on EKS (e.g., Super Mario) | Custom EKS with ingress, persistent volumes. | Advanced EKS addons, cert-manager. | `aws_eks_addon` for cert-manager. [EKS Addon Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) |
| **29** | Global CDN + WAF Setup | CloudFront/S3 + AWS WAF rules across regions. | Geo-routing, for_each loops. | `web_acl_association` rules. [CloudFront Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) |
| **30** | Enterprise Compliance Infra | VPC, EKS, secrets mgmt with audit logging. | Policy as code, Sentinel/Terraform Cloud. | Integrate `tfe_policy_set`. [TFE Docs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs) |

## 🛠️ Prerequisites

```bash
# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# AWS CLI, Azure CLI, GCP CLI setup required for respective projects
```

## 🚀 How to Use

1. **Clone this repo**
```bash
git clone <your-repo-url>
cd terraform-projects
```

2. **Pick a project** (e.g., Project 1)
```bash
cd projects/beginner/ec2-instance
```

3. **Configure variables**
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit with your credentials
```

4. **Deploy**
```bash
terraform init
terraform plan
terraform apply
```

## 📚 Learning Path

```
Beginner (1-10) → Basic Resources + Variables
     ↓
Intermediate (11-20) → Modules + Multi-Service
     ↓
Expert (21-30) → Advanced Patterns + Multi-Cloud
```

## 🤝 Contributing
1. Fork the repo
2. Create your feature branch (`git checkout -b feature/project-X`)
3. Add your Terraform project
4. Update README with new entry
5. Submit PR

## 📄 License
MIT License - See [LICENSE](LICENSE) file

## 🙌 Acknowledgments
- [Terraform Documentation](https://registry.terraform.io/)
- All cloud provider docs linked above
- Community contributions welcome!

***

*Built with ❤️ for Terraform learners -  Last Updated: Jan 2026*



