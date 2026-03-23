###############################################################
# ROOT outputs.tf
###############################################################

output "amplify_app_url" {
  description = "AWS Amplify hosted app URL"
  value       = module.amplify.app_url
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_app_client_id" {
  description = "Cognito App Client ID for the React UI"
  value       = module.cognito.app_client_id
}

output "api_gateway_url" {
  description = "Invoke URL for the REST API Gateway"
  value       = module.api_gateway.invoke_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "opensearch_endpoint" {
  description = "OpenSearch domain endpoint"
  value       = module.opensearch.endpoint
}

output "s3_document_bucket" {
  description = "S3 bucket for RAG document storage"
  value       = module.s3.document_bucket_name
}

output "dynamodb_workflow_table" {
  description = "DynamoDB table for workflow state and metadata"
  value       = module.dynamodb.workflow_table_name
}

output "step_functions_arn" {
  description = "Step Functions state machine ARN"
  value       = module.step_functions.state_machine_arn
}
