
resource "aws_s3_bucket" "s3_cloudtrail" {
  bucket_prefix = "cloudtrail-"
  force_destroy = true
}

locals {
  bucketname = aws_s3_bucket.s3_cloudtrail.id
  bucketarn  = aws_s3_bucket.s3_cloudtrail.arn
}

data "aws_iam_policy_document" "policy_cloudtrail" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [local.bucketarn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/root_user_usage"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${local.bucketarn}/${var.key_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/root_user_usage"]
    }
  }
}

resource "aws_s3_bucket_policy" "policy_cloudtrail" {
  bucket = local.bucketname
  policy = data.aws_iam_policy_document.policy_cloudtrail.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}
