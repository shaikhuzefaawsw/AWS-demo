###############################################################
# modules/opensearch/main.tf
# Amazon OpenSearch Service — vector engine enabled for RAG
###############################################################

resource "aws_cloudwatch_log_group" "opensearch" {
  name              = "/aws/opensearch/${var.project_name}-${var.environment}"
  retention_in_days = 7

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-opensearch-logs"
  })
}

resource "aws_cloudwatch_log_resource_policy" "opensearch" {
  policy_name = "${var.project_name}-${var.environment}-opensearch-log-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "es.amazonaws.com"
      }
      Action = [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ]
      Resource = "${aws_cloudwatch_log_group.opensearch.arn}:*"
    }]
  })
}

resource "aws_opensearch_domain" "main" {
  domain_name    = "${var.project_name}-${var.environment}"
  engine_version = "OpenSearch_2.11"   # Latest stable with vector engine

  cluster_config {
    instance_type  = var.opensearch_instance_type
    instance_count = var.opensearch_instance_count

    # For prod: enable dedicated master nodes
    # dedicated_master_enabled = true
    # dedicated_master_type    = "t3.small.search"
    # dedicated_master_count   = 3
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp3"
    volume_size = var.opensearch_volume_size
    throughput  = 125
  }

  # Enable vector engine (k-NN plugin) for RAG embeddings
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    "override_main_response_version"         = "false"
    "indices.fielddata.cache.size"           = "20"
  }

  # Encryption at rest
  encrypt_at_rest {
    enabled = true
  }

  # In-transit encryption
  node_to_node_encryption {
    enabled = true
  }

  # Enforce HTTPS
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  # Fine-grained access control (IAM-based)
  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = false   # Use IAM, not local users

    master_user_options {
      master_user_arn = "arn:aws:iam::${var.account_id}:root"
    }
  }

  # Access policy — allow account-level IAM control
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${var.account_id}:root" }
      Action    = "es:*"
      Resource  = "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.project_name}-${var.environment}/*"
    }]
  })

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-opensearch"
    Purpose = "RAG vector store"
  })
}
