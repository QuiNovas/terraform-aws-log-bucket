resource "aws_s3_bucket" "log" {
  acl    = "log-delivery-write"
  bucket = "${var.name_prefix}-log"
  lifecycle {
    prevent_destroy = true
  }
  lifecycle_rule {
    id      = "log"
    enabled = true

    transition {
      days          = var.transition_to_glacier
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "aws_elb_service_account" "main" {
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