###############################################################
# modules/step_functions/variables.tf
###############################################################
variable "project_name"            { type = string }
variable "environment"             { type = string }
variable "step_functions_role_arn" { type = string }
variable "ecs_cluster_arn"         { type = string }
variable "ecs_task_definition_arn" { type = string }
variable "ecs_subnet_ids"          { type = list(string) }
variable "ecs_security_group_id"   { type = string }
variable "dynamodb_table_name"     { type = string }
variable "tags"                    { type = map(string) }
