###############################################################
# modules/api_gateway/outputs.tf
###############################################################
output "invoke_url" {
  description = "Base URL to invoke the API"
  value       = aws_api_gateway_stage.main.invoke_url
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.main.id
}

output "stage_name" {
  value = aws_api_gateway_stage.main.stage_name
}
