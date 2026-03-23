###############################################################
# modules/iam/main.tf
#
# WHY IAM ROLES ARE NEEDED:
#
# 1. ECS Task Execution Role — allows ECS control-plane to:
#      · Pull the container image from ECR
#      · Write stdout/stderr logs to CloudWatch Logs
#    WITHOUT this role ECS cannot start your container.
#
# 2. ECS Task Role — identity assumed by YOUR code running
#    inside the container. Grants the app access to:
#      · S3 (read/write documents)
#      · DynamoDB (read/write workflow state)
#      · OpenSearch (index / query vectors)
#      · Step Functions (start executions)
#
# 3. Step Functions Role — allows the state machine to:
#      · Run ECS tasks (ecs:RunTask / iam:PassRole)
#      · Write execution logs to CloudWatch Logs
###############################################################

# ── ECS Task Execution Role ───────────────────────────────────
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-${var.environment}-ecs-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-ecs-exec-role" })
}

# AWS managed policy — covers ECR pull + CloudWatch Logs
resource "aws_iam_role_policy_attachment" "ecs_exec_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ── ECS Task Role (runtime permissions for your app code) ─────
resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-ecs-task-role" })
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "${var.project_name}-${var.environment}-ecs-task-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 — document read/write
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-${var.environment}-documents",
          "arn:aws:s3:::${var.project_name}-${var.environment}-documents/*"
        ]
      },
      # DynamoDB — workflow state + metadata
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${var.account_id}:table/${var.project_name}-${var.environment}-*"
      },
      # OpenSearch — index and search
      {
        Effect = "Allow"
        Action = [
          "es:ESHttpGet",
          "es:ESHttpPost",
          "es:ESHttpPut",
          "es:ESHttpDelete"
        ]
        Resource = "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.project_name}-${var.environment}/*"
      },
      # Step Functions — start workflow executions
      {
        Effect   = "Allow"
        Action   = ["states:StartExecution", "states:DescribeExecution"]
        Resource = "arn:aws:states:${var.aws_region}:${var.account_id}:stateMachine:${var.project_name}-${var.environment}-*"
      },
      # CloudWatch Logs — application logging
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/ecs/${var.project_name}-${var.environment}*"
      }
    ]
  })
}

# ── Step Functions Role ───────────────────────────────────────
resource "aws_iam_role" "step_functions" {
  name = "${var.project_name}-${var.environment}-sfn-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "states.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-sfn-role" })
}

resource "aws_iam_role_policy" "step_functions_policy" {
  name = "${var.project_name}-${var.environment}-sfn-policy"
  role = aws_iam_role.step_functions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Run ECS tasks
      {
        Effect   = "Allow"
        Action   = ["ecs:RunTask", "ecs:StopTask", "ecs:DescribeTasks"]
        Resource = "*"
      },
      # Pass the ECS task role to the ECS service
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = [
          aws_iam_role.ecs_task_execution.arn,
          aws_iam_role.ecs_task.arn
        ]
      },
      # CloudWatch Logs for state machine execution history
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogDelivery",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutLogEvents",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      }
    ]
  })
}
