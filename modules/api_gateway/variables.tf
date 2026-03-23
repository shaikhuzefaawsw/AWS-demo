###############################################################
# modules/api_gateway/variables.tf
###############################################################
variable "project_name"         { type = string }
variable "environment"          { type = string }
variable "cognito_user_pool_id" { type = string }
variable "tags"                 { type = map(string) }
