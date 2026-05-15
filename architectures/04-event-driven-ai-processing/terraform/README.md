# Terraform skeleton — Event-driven AI processing

Creates input + result EventBridge buses, the SQS queue + DLQ, the worker Lambda with reserved concurrency, idempotency + results DynamoDB tables, and a CloudWatch alarm on the DLQ.
