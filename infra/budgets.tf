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