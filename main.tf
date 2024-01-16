resource "aws_s3_bucket" "log" {
  bucket = local.s3_log_bucket_name
  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log" {
  bucket = aws_s3_bucket.log.bucket

  rule {
    id = "log"

    expiration {
      days = var.expiration
    }

    status = "Enabled"

    transition {
      days          = var.transition_to_glacier
      storage_class = "GLACIER"
    }
  }
}

data "aws_elb_service_account" "main" {
}

data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "log" {
  statement {
    actions = [
      "s3:PutObject",
    ]
    principals {
      identifiers = [
        data.aws_elb_service_account.main.arn,
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.log.arn}/elb/*",
    ]
    sid = "EnableELBLogging"
  }

  statement {
    actions = [
      "s3:*",
    ]
    condition {
      test = "Bool"
      values = [
        "false",
      ]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*",
      ]
      type = "AWS"
    }
    resources = [
      aws_s3_bucket.log.arn,
      "${aws_s3_bucket.log.arn}/*",
    ]
    sid = "DenyUnsecuredTransport"
  }

  statement {
    actions = [
      "s3:PutObject",
    ]
    condition {
      test = "StringEquals"
      values = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
    principals {
      identifiers = ["logging.s3.amazonaws.com"]
      type = "Service"
    }
    resources = [
      "${aws_s3_bucket.log.arn}/s3/*"
    ]
    sid = "EnableS3Logging"
  }
}

resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log.id
  policy = data.aws_iam_policy_document.log.json
}

resource "aws_s3_bucket_public_access_block" "log" {
  bucket                  = aws_s3_bucket.log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
