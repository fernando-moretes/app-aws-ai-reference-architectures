output "input_bus" {
  value = aws_cloudwatch_event_bus.input.name
}

output "result_bus" {
  value = aws_cloudwatch_event_bus.results.name
}

output "main_queue_url" {
  value = aws_sqs_queue.main.url
}

output "dlq_url" {
  value = aws_sqs_queue.dlq.url
}
