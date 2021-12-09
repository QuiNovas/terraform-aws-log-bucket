locals {
  s3_log_bucket_name = "${var.name_postfix}" == "" ? "${var.name_prefix}-log" : "${var.name_prefix}-log-${var.name_postfix}"
}