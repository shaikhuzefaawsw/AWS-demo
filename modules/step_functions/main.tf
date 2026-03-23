###############################################################
# modules/step_functions/main.tf
# AWS Step Functions — orchestrates RAG ingestion + query workflow
###############################################################

resource "aws_cloudwatch_log_group" "sfn" {
  name              = "/aws/states/${var.project_name}-${var.environment}"
  retention_in_days = 14

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-sfn-logs"
  })
}

resource "aws_sfn_state_machine" "rag_workflow" {
  name     = "${var.project_name}-${var.environment}-rag-workflow"
  role_arn = var.step_functions_role_arn

  # Express workflow = high-volume, short-lived (< 5 min) executions
  type = "STANDARD"

  definition = jsonencode({
    Comment = "RAG Agent document ingestion and query orchestration"
    StartAt = "ValidateInput"

    States = {

      ValidateInput = {
        Type    = "Pass"
        Comment = "Validate and enrich incoming request"
        Result  = { validated = true }
        Next    = "CheckWorkflowType"
      }

      CheckWorkflowType = {
        Type = "Choice"
        Choices = [
          {
            Variable      = "$.workflow_type"
            StringEquals  = "ingest"
            Next          = "IngestDocument"
          },
          {
            Variable      = "$.workflow_type"
            StringEquals  = "query"
            Next          = "QueryVectorStore"
          }
        ]
        Default = "UnknownWorkflowType"
      }

      # ── Ingest branch ───────────────────────────────────────
      IngestDocument = {
        Type     = "Task"
        Resource = "arn:aws:states:::ecs:runTask"
        Comment  = "Run ECS Fargate task to chunk and embed the document"
        Parameters = {
          LaunchType     = "FARGATE"
          Cluster        = var.ecs_cluster_arn
          TaskDefinition = var.ecs_task_definition_arn
          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = var.ecs_subnet_ids
              SecurityGroups = [var.ecs_security_group_id]
              AssignPublicIp = "DISABLED"
            }
          }
          Overrides = {
            ContainerOverrides = [{
              Name = "rag-agent"
              Environment = [
                { Name = "TASK_TYPE",    "Value.$" = "$.workflow_type" },
                { Name = "DOCUMENT_KEY", "Value.$" = "$.document_key" },
                { Name = "S3_BUCKET",    "Value.$" = "$.s3_bucket" }
              ]
            }]
          }
        }
        Next  = "UpdateIngestionState"
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Next        = "IngestionFailed"
        }]
      }

      UpdateIngestionState = {
        Type     = "Task"
        Resource = "arn:aws:states:::dynamodb:putItem"
        Comment  = "Write completion status to DynamoDB"
        Parameters = {
          TableName = var.dynamodb_table_name
          Item = {
            pk          = { "S.$" = "$.document_key" }
            sk          = { S    = "STATUS" }
            status      = { S    = "COMPLETED" }
            updated_at  = { "S.$" = "$$.Execution.StartTime" }
          }
        }
        End = true
      }

      IngestionFailed = {
        Type     = "Task"
        Resource = "arn:aws:states:::dynamodb:putItem"
        Parameters = {
          TableName = var.dynamodb_table_name
          Item = {
            pk     = { "S.$" = "$.document_key" }
            sk     = { S    = "STATUS" }
            status = { S    = "FAILED" }
          }
        }
        Next = "FailState"
      }

      # ── Query branch ────────────────────────────────────────
      QueryVectorStore = {
        Type     = "Task"
        Resource = "arn:aws:states:::ecs:runTask"
        Comment  = "Run ECS task to embed query and fetch top-k results"
        Parameters = {
          LaunchType     = "FARGATE"
          Cluster        = var.ecs_cluster_arn
          TaskDefinition = var.ecs_task_definition_arn
          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = var.ecs_subnet_ids
              SecurityGroups = [var.ecs_security_group_id]
              AssignPublicIp = "DISABLED"
            }
          }
          Overrides = {
            ContainerOverrides = [{
              Name = "rag-agent"
              Environment = [
                { Name = "TASK_TYPE",    "Value.$" = "$.workflow_type" },
                { Name = "QUERY_TEXT",   "Value.$" = "$.query_text" }
              ]
            }]
          }
        }
        End  = true
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Next        = "FailState"
        }]
      }

      UnknownWorkflowType = {
        Type  = "Fail"
        Error = "UnknownWorkflowType"
        Cause = "workflow_type must be 'ingest' or 'query'"
      }

      FailState = {
        Type  = "Fail"
        Error = "WorkflowFailed"
        Cause = "An error occurred during RAG workflow execution"
      }
    }
  })

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sfn.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  tracing_configuration {
    enabled = true
  }

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-rag-workflow"
    Purpose = "RAG ingestion and query orchestration"
  })
}
