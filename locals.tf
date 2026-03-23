###############################################################
# ROOT locals.tf
# Centralised tags applied to every resource via provider default_tags
###############################################################

data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "platform-team"
    CostCenter  = "engineering"
  }
}
