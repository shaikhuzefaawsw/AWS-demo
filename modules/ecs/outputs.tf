###############################################################
# modules/ecs/outputs.tf
###############################################################
output "cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  value = aws_ecs_service.agent.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.agent.arn
}

output "security_group_id" {
  value = aws_security_group.ecs_tasks.id
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}
