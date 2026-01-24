variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name: dev, staging, or prod"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "project_name" {
  description = "Name used for tagging and naming resources"
  type        = string
  default     = "cc-static-site"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket names"
  type        = string
  default     = "cc-static"
}

variable "enable_logging" {
  description = "Whether to enable CloudFront logging"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "Optional S3 bucket for logs"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}