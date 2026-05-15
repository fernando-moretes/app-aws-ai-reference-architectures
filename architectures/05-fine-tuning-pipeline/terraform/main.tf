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

locals {
  account = data.aws_caller_identity.current.account_id
}

# ----- Buckets --------------------------------------------------------------

resource "aws_s3_bucket" "raw" {
  bucket = "${var.project}-raw-${local.account}"
}

resource "aws_s3_bucket" "curated" {
  bucket = "${var.project}-curated-${local.account}"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-artifacts-${local.account}"
}

resource "aws_s3_bucket" "golden" {
  bucket              = "${var.project}-golden-${local.account}"
  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "golden" {
  bucket = aws_s3_bucket.golden.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_object_lock_configuration" "golden" {
  bucket = aws_s3_bucket.golden.id
  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 365
    }
  }
}

# ----- IAM ------------------------------------------------------------------

resource "aws_iam_role" "sagemaker" {
  name = "${var.project}-sagemaker"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "sagemaker.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "sagemaker" {
  role = aws_iam_role.sagemaker.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.curated.arn,
          "${aws_s3_bucket.curated.arn}/*",
          aws_s3_bucket.golden.arn,
          "${aws_s3_bucket.golden.arn}/*",
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.artifacts.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "*"
      },
    ]
  })
}

# ----- Step Functions (skeleton) -------------------------------------------

resource "aws_iam_role" "sfn" {
  name = "${var.project}-sfn"
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
    Statement = [{
      Effect = "Allow"
      Action = [
        "sagemaker:CreateTrainingJob",
        "sagemaker:DescribeTrainingJob",
        "sagemaker:CreateProcessingJob",
        "sagemaker:DescribeProcessingJob",
        "sagemaker:CreateModelPackage",
        "glue:StartJobRun",
        "glue:GetJobRun",
        "iam:PassRole",
      ]
      Resource = "*"
    }]
  })
}

resource "aws_sfn_state_machine" "pipeline" {
  name     = "${var.project}-pipeline"
  role_arn = aws_iam_role.sfn.arn
  definition = jsonencode({
    Comment = "Fine-tuning pipeline skeleton"
    StartAt = "ETL"
    States = {
      ETL = {
        Type     = "Task"
        Resource = "arn:aws:states:::glue:startJobRun.sync"
        Parameters = {
          "JobName.$" = "$.glue_job"
        }
        Next = "Train"
      }
      Train = {
        Type     = "Task"
        Resource = "arn:aws:states:::sagemaker:createTrainingJob.sync"
        Parameters = {
          "TrainingJobName.$" = "$.train_job"
          "RoleArn"           = aws_iam_role.sagemaker.arn
        }
        Next = "Evaluate"
      }
      Evaluate = {
        Type     = "Task"
        Resource = "arn:aws:states:::sagemaker:createProcessingJob.sync"
        Parameters = {
          "ProcessingJobName.$" = "$.eval_job"
          "RoleArn"             = aws_iam_role.sagemaker.arn
        }
        Next = "Register"
      }
      Register = {
        Type     = "Task"
        Resource = "arn:aws:states:::sagemaker:createModelPackage"
        End      = true
      }
    }
  })
}
