###############################################################
# modules/dynamodb/main.tf
# DynamoDB — workflow state + metadata store
###############################################################

resource "aws_dynamodb_table" "workflow" {
  name         = "${var.project_name}-${var.environment}-workflow-state"
  billing_mode = "PAY_PER_REQUEST"   # No capacity planning needed for dev
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  # GSI for querying by status
  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "sk"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true   # AES-256 at rest
  }

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-workflow-state"
    Purpose = "RAG workflow state and metadata"
  })
}

resource "aws_dynamodb_table" "metadata" {
  name         = "${var.project_name}-${var.environment}-metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "document_id"

  attribute {
    name = "document_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-metadata"
    Purpose = "RAG document metadata"
  })
}
