terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.50" }
  }
}

provider "aws" {
  region = var.region
}

# ----- Buses ----------------------------------------------------------------

resource "aws_cloudwatch_event_bus" "input" {
  name = "${var.project}-input"
}

resource "aws_cloudwatch_event_bus" "results" {
  name = "${var.project}-results"
}

# ----- Queue + DLQ ----------------------------------------------------------

resource "aws_sqs_queue" "dlq" {
  name                      = "${var.project}-dlq"
  message_retention_seconds = 1209600 # 14 days
}

resource "aws_sqs_queue" "main" {
  name                       = "${var.project}-q"
  visibility_timeout_seconds = 180
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}

resource "aws_cloudwatch_event_rule" "to_queue" {
  name           = "${var.project}-to-queue"
  event_bus_name = aws_cloudwatch_event_bus.input.name
  event_pattern = jsonencode({
    source = ["app", "saas"]
  })
}

resource "aws_cloudwatch_event_target" "to_queue" {
  rule           = aws_cloudwatch_event_rule.to_queue.name
  event_bus_name = aws_cloudwatch_event_bus.input.name
  target_id      = "queue"
  arn            = aws_sqs_queue.main.arn
}

# ----- Idempotency + results ------------------------------------------------

resource "aws_dynamodb_table" "idem" {
  name         = "${var.project}-idempotency"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "idempotency_key"
  attribute {
    name = "idempotency_key"
    type = "S"
  }
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}

resource "aws_dynamodb_table" "results" {
  name         = "${var.project}-results"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

# ----- Worker Lambda --------------------------------------------------------

resource "aws_iam_role" "worker" {
  name = "${var.project}-worker-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_basic" {
  role       = aws_iam_role.worker.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "worker_sqs" {
  role       = aws_iam_role.worker.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy" "worker_extra" {
  role = aws_iam_role.worker.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["bedrock:InvokeModel"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["dynamodb:PutItem", "dynamodb:UpdateItem"]
        Resource = [
          aws_dynamodb_table.idem.arn,
          aws_dynamodb_table.results.arn,
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["events:PutEvents"]
        Resource = aws_cloudwatch_event_bus.results.arn
      },
    ]
  })
}

resource "aws_lambda_function" "worker" {
  function_name                  = "${var.project}-worker"
  role                           = aws_iam_role.worker.arn
  runtime                        = "python3.12"
  handler                        = "worker.handler"
  filename                       = var.lambda_zip
  source_code_hash               = filebase64sha256(var.lambda_zip)
  timeout                        = 60
  memory_size                    = 512
  reserved_concurrent_executions = 20

  environment {
    variables = {
      IDEM_TABLE    = aws_dynamodb_table.idem.name
      RESULTS_TABLE = aws_dynamodb_table.results.name
      RESULT_BUS    = aws_cloudwatch_event_bus.results.name
      MODEL_ID      = var.model_id
    }
  }
}

resource "aws_lambda_event_source_mapping" "from_queue" {
  event_source_arn                   = aws_sqs_queue.main.arn
  function_name                      = aws_lambda_function.worker.arn
  batch_size                         = 5
  maximum_batching_window_in_seconds = 2
}

# ----- DLQ alarm ------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "dlq_has_messages" {
  alarm_name          = "${var.project}-dlq-not-empty"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    QueueName = aws_sqs_queue.dlq.name
  }
  alarm_description = "Messages in DLQ — investigate poison pills."
}
