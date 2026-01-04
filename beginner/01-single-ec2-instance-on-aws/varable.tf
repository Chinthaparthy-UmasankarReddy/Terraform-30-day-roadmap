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