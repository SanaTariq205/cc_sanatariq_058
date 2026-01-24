terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ------------------------
# Create S3 Bucket for Site
# ------------------------
module "s3_site" {
  source      = "./modules/s3_site"
  bucket_name = local.bucket_name
  oai_iam_arn = aws_cloudfront_origin_access_identity.oai.iam_arn
  tags        = local.common_tags
}

# ------------------------
# Create CloudFront OAI
# ------------------------
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.project_name}-${var.env}"
}

# ------------------------
# Create CloudFront Distribution
# ------------------------
module "cdn" {
  source             = "./modules/cloudfront"
  project_name       = var.project_name
  env                = var.env
  bucket_domain_name = module.s3_site.bucket_domain_name
  oai_id             = aws_cloudfront_origin_access_identity.oai.id
  comment            = "Static site for ${var.project_name}-${var.env}"
  enable_logging     = var.enable_logging
  logging_bucket     = var.logging_bucket
  tags               = local.common_tags
}
