project_name = "rag-agent"
environment  = "dev"
aws_region   = "us-east-1"

# ── Replace these with your actual VPC/subnet IDs ────────────
vpc_id     = "vpc-023799de24bc8894f"
subnet_ids = ["subnet-086ef0c28735e8e1e", "subnet-0e0d12434c6cc8ec6"]

# ── ECS Fargate ───────────────────────────────────────────────
container_image   = "public.ecr.aws/amazonlinux/amazonlinux:latest"
container_cpu     = 1024
container_memory  = 2048
ecs_desired_count = 1

# ── OpenSearch ────────────────────────────────────────────────
opensearch_instance_type  = "t3.small.search"
opensearch_instance_count = 1
opensearch_volume_size    = 20

