terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# ----- Corpus bucket --------------------------------------------------------

resource "aws_s3_bucket" "corpus" {
  bucket = "${var.project}-corpus-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "corpus" {
  bucket = aws_s3_bucket.corpus.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "corpus" {
  bucket = aws_s3_bucket.corpus.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----- OpenSearch Serverless vector collection ------------------------------

resource "aws_opensearchserverless_security_policy" "encryption" {
  name = "${var.project}-enc"
  type = "encryption"
  policy = jsonencode({
    Rules = [{
      ResourceType = "collection"
      Resource     = ["collection/${var.project}-kb"]
    }]
    AWSOwnedKey = true
  })
}

resource "aws_opensearchserverless_security_policy" "network" {
  name = "${var.project}-net"
  type = "network"
  policy = jsonencode([{
    Rules = [{
      ResourceType = "dashboard"
      Resource     = ["collection/${var.project}-kb"]
    }, {
      ResourceType = "collection"
      Resource     = ["collection/${var.project}-kb"]
    }]
    AllowFromPublic = true
  }])
}

resource "aws_opensearchserverless_collection" "kb" {
  name = "${var.project}-kb"
  type = "VECTORSEARCH"

  depends_on = [
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network,
  ]
}

# ----- Bedrock Knowledge Base ----------------------------------------------

resource "aws_iam_role" "kb" {
  name = "${var.project}-kb-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "bedrock.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "kb" {
  role = aws_iam_role.kb.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.corpus.arn,
          "${aws_s3_bucket.corpus.arn}/*",
        ]
      },
      {
        Effect   = "Allow"
        Action   = "bedrock:InvokeModel"
        Resource = "arn:aws:bedrock:${var.region}::foundation-model/amazon.titan-embed-text-v2:0"
      },
      {
        Effect   = "Allow"
        Action   = ["aoss:APIAccessAll"]
        Resource = aws_opensearchserverless_collection.kb.arn
      },
    ]
  })
}

# NOTE: aws_bedrockagent_knowledge_base requires the OpenSearch index to exist.
# In production, manage the index lifecycle separately (e.g. via a Lambda-backed
# custom resource) — left out of this skeleton on purpose.

# ----- Orchestrator Lambda --------------------------------------------------

resource "aws_iam_role" "lambda" {
  name = "${var.project}-orchestrator-role"
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

resource "aws_iam_role_policy" "lambda_bedrock" {
  role = aws_iam_role.lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["bedrock:RetrieveAndGenerate", "bedrock:Retrieve", "bedrock:InvokeModel"]
      Resource = "*"
    }]
  })
}
