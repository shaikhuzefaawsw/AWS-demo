###############################################################
# modules/opensearch/variables.tf
###############################################################
variable "project_name"              { type = string }
variable "environment"               { type = string }
variable "aws_region"                { type = string }
variable "account_id"                { type = string }
variable "opensearch_instance_type"  { type = string }
variable "opensearch_instance_count" { type = number }
variable "opensearch_volume_size"    { type = number }
variable "tags"                      { type = map(string) }
