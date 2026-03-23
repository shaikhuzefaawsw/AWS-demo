###############################################################
# modules/dynamodb/outputs.tf
###############################################################
output "workflow_table_name" {
  value = aws_dynamodb_table.workflow.name
}

output "workflow_table_arn" {
  value = aws_dynamodb_table.workflow.arn
}

output "metadata_table_name" {
  value = aws_dynamodb_table.metadata.name
}

output "metadata_table_arn" {
  value = aws_dynamodb_table.metadata.arn
}
