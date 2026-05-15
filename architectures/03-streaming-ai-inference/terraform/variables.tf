variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_zip" {
  description = "Path to a zipped Lambda deployment package."
  type        = string
}

variable "model_id" {
  description = "Bedrock model id, e.g. anthropic.claude-3-5-sonnet-20241022-v2:0"
  type        = string
  default     = "anthropic.claude-3-5-sonnet-20241022-v2:0"
}

variable "allowed_origins" {
  description = "CORS allowed origins for the Function URL."
  type        = list(string)
  default     = ["*"]
}
