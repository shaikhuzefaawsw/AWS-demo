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

# ── Amplify / GitHub (Optional) ───────────────────────────────
# To enable GitHub CI/CD, set these values:
# github_token = "ghp_YOUR_GITHUB_TOKEN_HERE"
# github_repo  = "https://gith1ub.com/YOUR_USERNAME/YOUR_REPO"
# github_branch = "main"

github_token = "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"
github_repo  = "https://github.com/shaikhuzefaawsw/AWS-demo"
github_branch = "master"
