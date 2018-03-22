#
# Providers
#
provider "template" { version = "~> 1.0" }
provider "null" { version = "~> 1.0" }
provider "local" { version = "~> 1.1" }

#
# Local variables
#
locals {
  enabled = "${var.allowed_workspace == terraform.workspace ? 1 : 0}"
}

#
# KMS Key
#
resource "aws_kms_key" "tf_enc_key" {
  count = "${local.enabled}"

  description             = "Global Terraform state encryption key"
  deletion_window_in_days = 30

  tags {
    terraform = "yes"
  }
}

#
# S3 Bucket
#
resource "aws_s3_bucket" "tf_state" {
  count = "${local.enabled}"

  bucket = "${var.bucket}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.tf_enc_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    terraform = "true"
  }
}

#
# S3 Bucket Policy
#
data "aws_iam_user" "tf_operators" {
  count = "${local.enabled*length(var.operators)}"

  user_name = "${var.operators[count.index]}"
}

data "aws_iam_policy_document" "tf_state_policy" {
  count = "${local.enabled}"

  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      "${aws_s3_bucket.tf_state.arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${data.aws_iam_user.tf_operators.arn}",
      ]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject"]

    resources = [
      "${aws_s3_bucket.tf_state.arn}/${var.key}",
      "${aws_s3_bucket.tf_state.arn}/env:/${var.key}",
    ]

    principals {
      type        = "AWS"
      identifiers = [
        "${data.aws_iam_user.tf_operators.arn}"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "tf_state_policy" {
  count = "${local.enabled}"

  bucket = "${aws_s3_bucket.tf_state.id}"
  policy = "${data.aws_iam_policy_document.tf_state_policy.json}"
}

#
# DynamoDB
#
resource "aws_dynamodb_table" "tf_state_lock" {
  count = "${local.enabled}"

  name           = "${var.bucket}-${var.dynamodb_table_suffix}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    terraform = "true"
  }
}

#
# backend.tf file
#
data "template_file" "backend_tf" {
  count = "${local.enabled}"

  template = "${file("${path.module}/templates/backend.tf")}"

  vars = {
    region         = "${var.region}"
    bucket         = "${aws_s3_bucket.tf_state.id}"
    key            = "${var.key}"
    dynamodb_table = "${aws_dynamodb_table.tf_state_lock.id}"
  }
}
resource "local_file" "backend_tf" {
  count = "${local.enabled}"

  content  = "${data.template_file.backend_tf.rendered}"
  filename = "backend.tf"
}
