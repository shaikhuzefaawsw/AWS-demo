###############################################################
# ROOT versions.tf
# Pin Terraform core and all provider versions explicitly
###############################################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # ── Remote State (optional — uncomment when using S3 backend) ──
  # backend "s3" {
  #   bucket         = "your-tfstate-bucket"
  #   key            = "rag-agent/dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  # Credentials are set via environment variables:
  #   export AWS_ACCESS_KEY_ID=...
  #   export AWS_SECRET_ACCESS_KEY=...
  # No hardcoded keys here — never commit credentials.

  default_tags {
    tags = local.common_tags
  }
}
