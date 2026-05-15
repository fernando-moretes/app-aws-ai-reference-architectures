# Terraform skeleton — Fine-tuning pipeline

Creates dataset / artifacts / golden-eval buckets (with Object Lock on the golden set), IAM roles for SageMaker, Step Functions state machine wiring training + eval + registry, and EventBridge scheduler for periodic runs.
