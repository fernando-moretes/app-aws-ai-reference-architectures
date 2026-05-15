variable "project" { type = string }
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "lambda_zip" { type = string }
variable "model_id" {
  type    = string
  default = "anthropic.claude-3-haiku-20240307-v1:0"
}
