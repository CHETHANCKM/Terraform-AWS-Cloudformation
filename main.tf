terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
    region     = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}

# Fetch AWS Account ID dynamically
data "aws_caller_identity" "current" {}

# Replace Account ID in template.json dynamically
resource "aws_cloudformation_stack" "ec2_stack" {
  name          = "FileTransfer"
  template_body = templatefile("template.json", { account_id = data.aws_caller_identity.current.account_id })

  capabilities = ["CAPABILITY_NAMED_IAM"]

}