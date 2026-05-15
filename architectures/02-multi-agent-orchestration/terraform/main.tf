terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.50" }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# ----- Artifacts bucket -----------------------------------------------------

resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-artifacts-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  rule {
    id     = "expire-intermediates"
    status = "Enabled"
    filter { prefix = "intermediate/" }
    expiration { days = 14 }
  }
}

# ----- Workflow state table -------------------------------------------------

resource "aws_dynamodb_table" "workflows" {
  name         = "${var.project}-workflows"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "workflow_id"
  attribute {
    name = "workflow_id"
    type = "S"
  }
  point_in_time_recovery { enabled = true }
}

# ----- Step Functions state machine -----------------------------------------

resource "aws_iam_role" "sfn" {
  name = "${var.project}-sfn-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "states.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "sfn" {
  role = aws_iam_role.sfn.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["lambda:InvokeFunction"]
        Resource = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.project}-*"
      },
      {
        Effect   = "Allow"
        Action   = ["bedrock:InvokeAgent"]
        Resource = "*"
      },
    ]
  })
}

resource "aws_sfn_state_machine" "main" {
  name     = "${var.project}-workflow"
  role_arn = aws_iam_role.sfn.arn
  type     = "STANDARD"

  definition = jsonencode({
    Comment = "Multi-agent orchestration skeleton"
    StartAt = "SearchAgent"
    States = {
      SearchAgent = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = "${var.project}-invoke-agent"
          Payload = {
            "agent_id.$" = "$.search_agent_id"
            "input.$"    = "$.query"
          }
        }
        Next = "SummaryFanOut"
      }
      SummaryFanOut = {
        Type           = "Map"
        ItemsPath      = "$.sources"
        MaxConcurrency = 10
        Iterator = {
          StartAt = "SummariseOne"
          States = {
            SummariseOne = {
              Type     = "Task"
              Resource = "arn:aws:states:::lambda:invoke"
              Parameters = {
                FunctionName = "${var.project}-invoke-agent"
              }
              End = true
            }
          }
        }
        Next = "Writer"
      }
      Writer = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke.waitForTaskToken"
        Parameters = {
          FunctionName = "${var.project}-invoke-agent"
        }
        End = true
      }
    }
  })
}
