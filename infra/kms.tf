resource "aws_kms_key" "s3_key" {
  description         = "CMK for S3 encryption"
  enable_key_rotation = true
  tags                = var.default_tags
}