output "corpus_bucket" {
  value       = aws_s3_bucket.corpus.bucket
  description = "S3 bucket where the corpus lives — the KB watches this bucket."
}

output "collection_endpoint" {
  value       = aws_opensearchserverless_collection.kb.collection_endpoint
  description = "OpenSearch Serverless vector collection endpoint."
}

output "kb_role_arn" {
  value       = aws_iam_role.kb.arn
  description = "IAM role assumed by the Bedrock Knowledge Base."
}
