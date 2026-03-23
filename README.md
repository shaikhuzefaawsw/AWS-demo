# RAG Agent Platform — Terraform Infrastructure

## Architecture

```
Frontend Layer      →  AWS Amplify (React UI)  +  Amazon Cognito
API Layer           →  Amazon API Gateway (Cognito-authenticated)
Compute Layer       →  Amazon ECS Fargate (RAG agent container)
Orchestration       →  AWS Step Functions (Express workflow)
Vector + Data Layer →  Amazon OpenSearch (k-NN vector engine)
                        Amazon S3 (document storage)
                        Amazon DynamoDB (metadata + workflow state)
```

---

## Project Structure

```
rag-infra/
├── main.tf             ← Root orchestrator — calls all modules
├── variables.tf        ← All input variable declarations
├── outputs.tf          ← Root outputs (URLs, IDs, etc.)
├── locals.tf           ← Common tags + computed locals
├── versions.tf         ← Terraform + provider version pins
├── terraform.tfvars    ← Your environment values (edit this)
├── .gitignore
└── modules/
    ├── iam/            ← ECS execution role, task role, SFN role
    ├── s3/             ← Document storage bucket
    ├── dynamodb/       ← Workflow state + metadata tables
    ├── cognito/        ← User Pool + App Client + Identity Pool
    ├── opensearch/     ← Vector search domain (k-NN enabled)
    ├── ecs/            ← Fargate cluster, task def, service, autoscaling
    ├── api_gateway/    ← REST API with Cognito authorizer
    ├── step_functions/ ← RAG ingest + query state machine
    └── amplify/        ← React UI hosting + CI/CD
```

---

## Prerequisites

- Terraform >= 1.6.0
- An existing AWS VPC with at least 2 private subnets
- AWS credentials exported in your shell

---

## Quick Start

### 1 — Export credentials
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# GitHub token for Amplify (keep out of tfvars)
export TF_VAR_github_token="ghp_xxxxxxxxxxxx"
```

### 2 — Edit terraform.tfvars
```hcl
vpc_id     = "vpc-xxxxxxxxxxxxxxxxx"   # your real VPC
subnet_ids = ["subnet-xxx", "subnet-yyy"]
github_repo = "https://github.com/your-org/your-ui-repo"
```

### 3 — Deploy
```bash
cd rag-infra/
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 4 — View outputs
```bash
terraform output
```

---

## Why IAM Roles Are Required

| Role | Service | Why Needed |
|------|---------|-----------|
| `ecs-exec-role` | ECS control plane | Pull image from ECR, write logs to CloudWatch |
| `ecs-task-role` | Your app code | Access S3, DynamoDB, OpenSearch, Step Functions |
| `sfn-role` | Step Functions | Run ECS tasks (`ecs:RunTask`), pass roles, write logs |

Without these, ECS containers cannot start and Step Functions cannot invoke tasks.

---

## Updating the Container Image

Edit `terraform.tfvars`:
```hcl
container_image = "123456789.dkr.ecr.us-east-1.amazonaws.com/rag-agent:v2"
```
Then: `terraform apply`

---

## Destroy All Resources
```bash
terraform destroy
```
