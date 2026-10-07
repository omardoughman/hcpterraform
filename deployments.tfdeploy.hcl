identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    aws_region     = "us-east-1"
    role_arn       = "arn:aws:iam::123456789012:role/HCPTerraformStacksRole-Dev"
    identity_token = identity_token.aws.jwt
    vpc_cidr       = "10.10.0.0/16"
  }
}
