variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "oai_iam_arn" {
  description = "IAM ARN of the CloudFront Origin Access Identity"
  type        = string
}

variable "tags" {
  description = "Tags for the bucket"
  type        = map(string)
}