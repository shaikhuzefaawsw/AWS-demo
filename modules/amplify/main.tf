###############################################################
# modules/amplify/main.tf
# AWS Amplify — hosts the React UI with CI/CD from GitHub
###############################################################

resource "aws_amplify_app" "main" {
  name = "${var.project_name}-${var.environment}-ui"

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - cd sample-app
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: sample-app/build
        files:
          - '**/*'
      cache:
        paths:
          - sample-app/node_modules/**/*
  EOT

  repository  = var.github_repo != "" ? var.github_repo : null
  oauth_token = var.github_token != "" ? var.github_token : null

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  environment_variables = {
    ENV      = var.environment
    NODE_ENV = var.environment == "prod" ? "production" : "development"
    PROJECT  = var.project_name
  }

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-ui"
    Purpose = "RAG platform React frontend"
  })
}

# GitHub connection (if token and repo are provided)
resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = var.github_branch
  framework   = "React"
  stage       = var.environment == "prod" ? "PRODUCTION" : "DEVELOPMENT"

  # Enable auto build for GitHub-connected branches
  enable_auto_build = var.github_token != "" ? true : false

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-branch"
  })
}

# GitHub repository connection (optional)
resource "aws_amplify_backend_environment" "github" {
  count           = var.github_token != "" ? 1 : 0
  app_id          = aws_amplify_app.main.id
  environment_name = var.environment

  deployment_artifacts = aws_amplify_app.main.name
  stack_name           = "${var.project_name}-${var.environment}"
}