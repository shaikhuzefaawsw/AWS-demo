###############################################################
# ROOT variables.tf
###############################################################

variable "project_name" {
  description = "Name of the project — used in all resource names and tags"
  type        = string
  default     = "rag-agent"
}

variable "environment" {
  description = "Deployment environment (dev / staging / prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy all resources"
  type        = string
  default     = "us-east-1"
}

# ── Networking ────────────────────────────────────────────────
variable "vpc_id" {
  description = "VPC ID where ECS tasks and OpenSearch will run"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks (private subnets recommended)"
  type        = list(string)
}

# ── ECS / Fargate ─────────────────────────────────────────────
variable "container_image" {
  description = "Docker image URI for the RAG agent (ECR or Docker Hub)"
  type        = string
  default     = "public.ecr.aws/amazonlinux/amazonlinux:latest"
}

variable "container_cpu" {
  description = "CPU units for the ECS task (256 / 512 / 1024 / 2048 / 4096)"
  type        = number
  default     = 1024
}

variable "container_memory" {
  description = "Memory (MiB) for the ECS task"
  type        = number
  default     = 2048
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

# ── OpenSearch ────────────────────────────────────────────────
variable "opensearch_instance_type" {
  description = "OpenSearch node instance type"
  type        = string
  default     = "t3.small.search"
}

variable "opensearch_instance_count" {
  description = "Number of OpenSearch data nodes"
  type        = number
  default     = 1
}

variable "opensearch_volume_size" {
  description = "EBS volume size (GiB) per OpenSearch node"
  type        = number
  default     = 20
}

