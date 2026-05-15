output "function_url" {
  value       = aws_lambda_function_url.stream.function_url
  description = "Streaming endpoint — POST chat messages here."
}

output "cdn_domain" {
  value       = aws_cloudfront_distribution.ui.domain_name
  description = "CloudFront domain serving the chat UI."
}
