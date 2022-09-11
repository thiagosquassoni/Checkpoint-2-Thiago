# PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
 bucket = "aws-s3-thiago-rm95610-checkpoint02"  
}

# S3 Bucket - Config Static Website
resource "aws_s3_bucket_website_configuration" "bucket-website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
    error_document {
      key = "error.html"
 }
}

# S3 Bucket - Config ACL
resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.bucket.id
  acl = "public-read"
}

#S3 UPLOAD OBJECT
resource "aws_s3_bucket_object" "bucket-error" {
  key          = "error.html"
  bucket       = aws_s3_bucket.bucket.id
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "bucket-index" {
  key          = "index.html"
  bucket       = aws_s3_bucket.bucket.id
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

# POLICY S3
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.id

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::aws-s3-thiago-rm95610-checkpoint02/*",
      }
    ]
	})
}
# VERSIONING S3 BUCKET
resource "aws_s3_bucket_versioning" "versionTH" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
