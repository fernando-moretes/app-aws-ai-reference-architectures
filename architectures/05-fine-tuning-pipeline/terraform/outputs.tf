output "buckets" {
  value = {
    raw       = aws_s3_bucket.raw.bucket
    curated   = aws_s3_bucket.curated.bucket
    artifacts = aws_s3_bucket.artifacts.bucket
    golden    = aws_s3_bucket.golden.bucket
  }
}

output "pipeline_arn" {
  value = aws_sfn_state_machine.pipeline.arn
}
