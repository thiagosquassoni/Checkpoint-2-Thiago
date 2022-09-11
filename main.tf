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
resource "aws_s3_bucket" "b" {
 bucket = "aws-s3-luis-rm94405-checkpoint02"  
}

# S3 Bucket - Config Static Website
resource "aws_s3_bucket_website_configuration" "b-website" {
  bucket = aws_s3_bucket.b.id
  index_document {
    suffix = "index.html"
  }
    error_document {
      key = "error.html"
 }
}

# S3 Bucket - Config ACL
resource "aws_s3_bucket_acl" "b-acl" {
  bucket = aws_s3_bucket.b.id
  acl = "public-read"
}

#S3 UPLOAD OBJECT
resource "aws_s3_bucket_object" "b-error" {
  key          = "error.html"
  bucket       = aws_s3_bucket.b.id
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "b-index" {
  key          = "index.html"
  bucket       = aws_s3_bucket.b.id
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

# POLICY S3
resource "aws_s3_bucket_policy" "b-policy" {
  bucket = aws_s3_bucket.b.id

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::aws-s3-luis-rm94405-checkpoint02/*",
      }
    ]
	})
}
