###############################################################
# modules/step_functions/outputs.tf
###############################################################
output "state_machine_arn" {
  value = aws_sfn_state_machine.rag_workflow.arn
}

output "state_machine_name" {
  value = aws_sfn_state_machine.rag_workflow.name
}
