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
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

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

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = var.environment == "prod" ? "main" : var.environment
  framework   = "React"
  stage       = var.environment == "prod" ? "PRODUCTION" : "DEVELOPMENT"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-branch"
  })
}