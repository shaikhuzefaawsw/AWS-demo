###############################################################
# modules/opensearch/outputs.tf
###############################################################
output "endpoint" {
  value = aws_opensearch_domain.main.endpoint
}

output "domain_arn" {
  value = aws_opensearch_domain.main.arn
}

output "domain_name" {
  value = aws_opensearch_domain.main.domain_name
}

output "kibana_endpoint" {
  description = "OpenSearch Dashboards URL"
  value       = aws_opensearch_domain.main.dashboard_endpoint
}
