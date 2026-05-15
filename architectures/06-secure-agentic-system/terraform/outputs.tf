output "kill_switch_arn" {
  value       = aws_ssm_parameter.kill_switch.arn
  description = "Flip this to 'false' to immediately disable the agent."
}

output "guardrail_id" {
  value = aws_bedrock_guardrail.default.guardrail_id
}

output "memory_table" {
  value = aws_dynamodb_table.memory.name
}
