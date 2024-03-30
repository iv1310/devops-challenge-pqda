data "aws_iam_policy_document" "this" {
  count = var.create_bucket ? 1 : 0
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [aws_s3_bucket.this[0].arn]
    effect    = "Allow"
  }
}

resource "aws_s3_bucket" "this" {
  count = var.create_bucket ? 1 : 0

  bucket              = "${var.bucket_name}-${var.suffix_name}"
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled

  tags = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    id     = "delete-objects-after-${var.lifecycle_days}-days"
    status = "Enabled"

    expiration {
      days = var.lifecycle_days
    }
  }
}

resource "aws_iam_policy" "this" {
  count       = var.create_bucket ? 1 : 0
  name        = "${var.policy_name}-${var.suffix_name}"
  description = "Policy to allow access to ${var.bucket_name} S3 bucket"

  policy = data.aws_iam_policy_document.this[0].json
}

resource "aws_iam_group" "this" {
  count = var.create_bucket ? 1 : 0
  name  = "${var.group_name}-${var.suffix_name}"
}

resource "aws_iam_group_policy_attachment" "this" {
  count      = var.create_bucket ? 1 : 0
  group      = aws_iam_group.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_user" "this" {
  count = var.create_bucket ? 1 : 0
  name  = "${var.user_name}-${var.suffix_name}"
  path  = "/"
}

resource "aws_iam_group_membership" "user_membership" {
  count = var.create_bucket ? 1 : 0
  name  = aws_iam_group.this[0].name
  group = aws_iam_group.this[0].name
  users = [aws_iam_user.this[0].name]
}
