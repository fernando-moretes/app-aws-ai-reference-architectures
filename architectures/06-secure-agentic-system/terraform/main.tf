terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.50" }
  }
}

provider "aws" {
  region = var.region
}

# ----- Kill switch ----------------------------------------------------------

resource "aws_ssm_parameter" "kill_switch" {
  name  = "/${var.project}/agent/enabled"
  type  = "String"
  value = "true"
}

# ----- Memory + rate limits -------------------------------------------------

resource "aws_dynamodb_table" "memory" {
  name         = "${var.project}-memory"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "tenant_session"
  attribute {
    name = "tenant_session"
    type = "S"
  }
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}

resource "aws_dynamodb_table" "rate_limits" {
  name         = "${var.project}-rate-limits"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "tenant_id"
  attribute {
    name = "tenant_id"
    type = "S"
  }
}

# ----- Bedrock guardrail ----------------------------------------------------

resource "aws_bedrock_guardrail" "default" {
  name                      = "${var.project}-guardrail"
  blocked_input_messaging   = "I cannot process this request."
  blocked_outputs_messaging = "I cannot share that information."

  content_policy_config {
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "HATE"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "VIOLENCE"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "SEXUAL"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "INSULTS"
    }
  }

  sensitive_information_policy_config {
    pii_entities_config {
      action = "BLOCK"
      type   = "EMAIL"
    }
    pii_entities_config {
      action = "BLOCK"
      type   = "PHONE"
    }
  }
}

# ----- IAM ------------------------------------------------------------------

resource "aws_iam_role" "agent" {
  name = "${var.project}-agent-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "bedrock.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "authorizer" {
  name = "${var.project}-authorizer-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "authorizer" {
  role = aws_iam_role.authorizer.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter"]
        Resource = aws_ssm_parameter.kill_switch.arn
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:UpdateItem", "dynamodb:GetItem"]
        Resource = aws_dynamodb_table.rate_limits.arn
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "*"
      },
    ]
  })
}

# ----- VPC for action groups (skeleton refs - bring your own VPC module) ---

# Action-group Lambdas should attach to private subnets with NO internet route.
# Bedrock agent runtime is reachable via VPC interface endpoint:
# com.amazonaws.<region>.bedrock-agent-runtime
