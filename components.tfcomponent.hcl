# Declare the provider requirements for the stack compiler
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}

# Configure the provider instance using cross-environment stack variables
provider "aws" "main" {
  config {
    region = var.aws_region

    # Safely assume an IAM role dynamically using OIDC token details
    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.identity_token
    }
  }
}

# Define the root-level variables accepted by the stack
variable "aws_region" {
  type        = string
  description = "Target deployment region"
}

variable "role_arn" {
  type        = string
  description = "The target AWS IAM Role ARN to assume via OIDC"
}

variable "identity_token" {
  type        = string
  description = "The transient JWT identity token emitted by HCP Terraform"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the environment VPC"
}

# Define your infrastructure block by pulling a public or private registry module
component "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  providers = {
    aws = provider.aws.main
  }

  inputs = {
    name = "hcp-stack-network"
    cidr = var.vpc_cidr
    azs  = ["${var.aws_region}a", "${var.aws_region}b"]
  }
}

# Expose output values back to the HCP Terraform platform UI
output "vpc_id" {
  value       = component.vpc.vpc_id
  description = "The ID of the provisioned VPC infrastructure"
}
