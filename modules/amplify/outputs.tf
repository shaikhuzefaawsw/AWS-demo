###############################################################
# modules/amplify/outputs.tf
###############################################################
output "app_id" {
  value = aws_amplify_app.main.id
}

output "app_arn" {
  description = "ARN of the Amplify app"
  value       = aws_amplify_app.main.arn
}

output "app_url" {
  description = "Default Amplify hosted URL"
  value       = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.main.default_domain}"
}

output "default_domain" {
  value = aws_amplify_app.main.default_domain
}

output "repository_name" {
  description = "Name of the Amplify app for Git connection"
  value       = aws_amplify_app.main.name
}

output "deployment_instructions" {
  description = "Instructions for deploying the sample app"
  value       = <<-EOT
    Sample RAG Application Deployment Instructions:
    
    1. To deploy the sample React app:
       - Navigate to: sample-app/
       - Run: npm install
       - Run: npm run build
       - The build/ folder is ready to deploy
    
    2. Option A - GitHub CI/CD:
       - Push sample-app to GitHub repository
       - Connect GitHub via AWS Amplify console
       - Amplify will automatically build and deploy
    
    3. Option B - Manual Deployment:
       - Build locally: npm run build
       - Use AWS Amplify console to upload the build/ folder
       - Or use AWS CLI: amplify-cli publish
    
    4. View your app at:
       https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.main.default_domain}
  EOT
}
