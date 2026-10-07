required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}

provider "aws" "main" {
  config {
    region = var.aws_region
    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.identity_token
    }
  }
}

variable "aws_region" { type = string }
variable "role_arn" { type = string }
variable "identity_token" { type = string }
variable "vpc_cidr" { type = string }

component "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  providers = { aws = provider.aws.main }
  inputs = {
    name = "hcp-stack-network"
    cidr = var.vpc_cidr
    azs  = ["${var.aws_region}a", "${var.aws_region}b"]
  }
}

output "vpc_id" { value = component.vpc.vpc_id }
