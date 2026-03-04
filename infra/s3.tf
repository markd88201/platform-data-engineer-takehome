resource "aws_s3_bucket" "raw" {
  bucket = local.raw_bucket_name
  tags   = var.default_tags
}

resource "aws_s3_bucket" "curated" {
  bucket = local.curated_bucket_name
  tags   = var.default_tags
}

resource "aws_s3_bucket_public_access_block" "raw_block" {
  bucket                  = aws_s3_bucket.raw.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_public_access_block" "curated_block" {
  bucket                  = aws_s3_bucket.curated.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}