resource "aws_s3_bucket_versioning" "curated_versioning" {
  bucket = aws_s3_bucket.curated.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_policy" "databricks_s3_policy" {
  name = "databricks-s3-policy-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.raw.arn,
          "${aws_s3_bucket.raw.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.curated.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "databricks_attach" {
  role       = aws_iam_role.databricks_job_role.name
  policy_arn = aws_iam_policy.databricks_s3_policy.arn
}

resource "aws_iam_role" "ci_role" {
  name = "terraform-ci-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "github-actions.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.default_tags
}

resource "aws_iam_policy" "ci_policy" {
  name = "terraform-ci-policy-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:*",
        "iam:*",
        "kms:*",
        "budgets:*",
        "config:*"
      ]
      Resource = "*"
    }]
  })
}