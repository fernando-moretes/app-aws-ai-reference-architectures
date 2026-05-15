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

# ----- Conversation memory --------------------------------------------------

resource "aws_dynamodb_table" "memory" {
  name         = "${var.project}-memory"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "conversation_id"
  range_key    = "ts"
  attribute {
    name = "conversation_id"
    type = "S"
  }
  attribute {
    name = "ts"
    type = "N"
  }
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}

# ----- Streaming Lambda + Function URL --------------------------------------

resource "aws_iam_role" "lambda" {
  name = "${var.project}-stream-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_extra" {
  role = aws_iam_role.lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["bedrock:InvokeModelWithResponseStream", "bedrock:InvokeModel"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query"]
        Resource = aws_dynamodb_table.memory.arn
      },
    ]
  })
}

resource "aws_lambda_function" "stream" {
  function_name = "${var.project}-stream"
  role          = aws_iam_role.lambda.arn
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  filename      = var.lambda_zip
  source_code_hash = filebase64sha256(var.lambda_zip)
  timeout       = 60
  memory_size   = 1024

  environment {
    variables = {
      MEMORY_TABLE = aws_dynamodb_table.memory.name
      MODEL_ID     = var.model_id
    }
  }
}

resource "aws_lambda_function_url" "stream" {
  function_name      = aws_lambda_function.stream.function_name
  authorization_type = "AWS_IAM"
  invoke_mode        = "RESPONSE_STREAM"

  cors {
    allow_origins = var.allowed_origins
    allow_methods = ["POST"]
    allow_headers = ["content-type", "authorization"]
  }
}

# ----- Static UI on S3 + CloudFront -----------------------------------------

resource "aws_s3_bucket" "ui" {
  bucket = "${var.project}-ui-${data.aws_caller_identity.current.account_id}"
}

resource "aws_cloudfront_origin_access_control" "ui" {
  name                              = "${var.project}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "ui" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.ui.bucket_regional_domain_name
    origin_id                = "ui-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.ui.id
  }

  default_cache_behavior {
    target_origin_id       = "ui-s3"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
