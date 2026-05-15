output "state_machine_arn" {
  value       = aws_sfn_state_machine.main.arn
  description = "Step Functions state machine ARN — start executions against this."
}

output "artifacts_bucket" {
  value       = aws_s3_bucket.artifacts.bucket
  description = "S3 bucket where intermediate and final artifacts live."
}

output "workflows_table" {
  value       = aws_dynamodb_table.workflows.name
  description = "DynamoDB table for workflow state."
}
