variable "project" {
  description = "Project name used as resource prefix."
  type        = string
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}
