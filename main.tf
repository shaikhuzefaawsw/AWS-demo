module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  account_id   = data.aws_caller_identity.current.account_id
  tags         = local.common_tags
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "cognito" {
  source       = "./modules/cognito"
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "opensearch" {
  source                    = "./modules/opensearch"
  project_name              = var.project_name
  environment               = var.environment
  opensearch_instance_type  = var.opensearch_instance_type
  opensearch_instance_count = var.opensearch_instance_count
  opensearch_volume_size    = var.opensearch_volume_size
  account_id                = data.aws_caller_identity.current.account_id
  aws_region                = var.aws_region
  tags                      = local.common_tags
}

module "ecs" {
  source                    = "./modules/ecs"
  project_name              = var.project_name
  environment               = var.environment
  aws_region                = var.aws_region
  ecs_task_execution_role   = module.iam.ecs_task_execution_role_arn
  ecs_task_role             = module.iam.ecs_task_role_arn
  container_image           = var.container_image
  container_cpu             = var.container_cpu
  container_memory          = var.container_memory
  desired_count             = var.ecs_desired_count
  vpc_id                    = var.vpc_id
  subnet_ids                = var.subnet_ids
  tags                      = local.common_tags
}

module "api_gateway" {
  source              = "./modules/api_gateway"
  project_name        = var.project_name
  environment         = var.environment
  cognito_user_pool_id = module.cognito.user_pool_id
  tags                = local.common_tags
}

module "step_functions" {
  source                      = "./modules/step_functions"
  project_name                = var.project_name
  environment                 = var.environment
  step_functions_role_arn     = module.iam.step_functions_role_arn
  ecs_cluster_arn             = module.ecs.cluster_arn
  ecs_task_definition_arn     = module.ecs.task_definition_arn
  ecs_subnet_ids              = var.subnet_ids
  ecs_security_group_id       = module.ecs.security_group_id
  dynamodb_table_name         = module.dynamodb.workflow_table_name
  tags                        = local.common_tags
}

module "amplify" {
  source       = "./modules/amplify"
  project_name = var.project_name
  environment  = var.environment
  github_token = var.github_token
  github_repo  = var.github_repo
  github_branch = var.github_branch
  tags         = local.common_tags
}