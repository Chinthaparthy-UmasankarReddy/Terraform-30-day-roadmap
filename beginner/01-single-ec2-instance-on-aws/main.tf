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
    cidr_blocks = ["0.0.0.0/0"] # TODO: Restrict to your IP in production
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
  default_for_az    = true
  availability_zone = "${var.aws_region}a"
}