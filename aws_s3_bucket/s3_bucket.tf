provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "s3_bucket_pac" {
  bucket   = var.pac_s3_bucket_name
  acl      = "private"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_s3_bucket_policy" "s3_bucket_pac_policy" {
  bucket   = aws_s3_bucket.s3_bucket_pac.id
  policy   = data.aws_iam_policy_document.s3_pac_policy_document.json
}

data "aws_iam_policy_document" "s3_pac_policy_document" {
  statement {
    sid    = "PacFilePolicy"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "S3:GetObject"
    ]

    resources = ["${aws_s3_bucket.s3_bucket_pac.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpce"

      values = var.pac_allowed_vpces
    }
  }
}



resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket   = aws_s3_bucket.s3_bucket_pac.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true
}

