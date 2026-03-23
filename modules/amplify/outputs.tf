###############################################################
# modules/amplify/outputs.tf
###############################################################
output "app_id" {
  value = aws_amplify_app.main.id
}

output "app_url" {
  description = "Default Amplify hosted URL"
  value       = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.main.default_domain}"
}

output "default_domain" {
  value = aws_amplify_app.main.default_domain
}
