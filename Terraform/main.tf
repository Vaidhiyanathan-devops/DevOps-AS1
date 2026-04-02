# terraform/aws/bootstrap/main.tf
#
# Run this ONCE before any environment `terraform init`.
# This creates the remote state backend infrastructure.
# State for this bootstrap is stored locally — commit the .tfstate
# to a private location or accept it as a one-time manual step.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Intentionally NO remote backend here — chicken-and-egg problem.
  # This tfstate is small and stable; store it safely offline.
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  envs = ["dev", "staging", "prod"]
}

# ── S3 State Buckets (one per environment) ────────────────────────────────────
resource "aws_s3_bucket" "tfstate" {
  for_each = toset(local.envs)

  bucket        = "pgagi-tfstate-${each.key}"
  force_destroy = false  # Safety: never auto-delete state

  tags = {
    Project   = "pgagi"
    ManagedBy = "terraform-bootstrap"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  for_each = aws_s3_bucket.tfstate

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  for_each = aws_s3_bucket.tfstate

  bucket = each.value.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  for_each = aws_s3_bucket.tfstate

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ── DynamoDB Lock Table (shared across all envs — key is the state path) ──────
resource "aws_dynamodb_table" "tf_lock" {
  name         = "pgagi-tf-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project   = "pgagi"
    ManagedBy = "terraform-bootstrap"
  }
}
