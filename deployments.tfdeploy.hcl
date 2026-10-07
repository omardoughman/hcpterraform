# 1. Instruct HCP Terraform to generate a secure, short-lived OIDC JWT token
identity_token "aws" {
  audience = ["aws.workload.identity"]
}

# 2. Map structural deployments (Environments) and pass explicit variable inputs
deployment "development" {
  inputs = {
    aws_region     = "us-east-1"
    role_arn       = "arn:aws:iam::123456789012:role/HCPTerraformStacksRole-Dev"
    identity_token = identity_token.aws.jwt
    vpc_cidr       = "10.10.0.0/16"
  }
}

deployment "production" {
  inputs = {
    aws_region     = "us-west-2"
    role_arn       = "arn:aws:iam::123456789012:role/HCPTerraformStacksRole-Prod"
    identity_token = identity_token.aws.jwt
    vpc_cidr       = "10.20.0.0/16"
  }
}
