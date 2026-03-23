###############################################################
# modules/ecs/variables.tf
###############################################################
variable "project_name"            { type = string }
variable "environment"             { type = string }
variable "aws_region"              { type = string }
variable "ecs_task_execution_role" { type = string }
variable "ecs_task_role"           { type = string }
variable "container_image"         { type = string }
variable "container_cpu"           { type = number }
variable "container_memory"        { type = number }
variable "desired_count"           { type = number }
variable "vpc_id"                  { type = string }
variable "subnet_ids"              { type = list(string) }
variable "tags"                    { type = map(string) }
