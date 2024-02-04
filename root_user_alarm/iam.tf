
resource "aws_iam_role" "cloudtrail_role" {
  name               = "RootUsageCloudTrailRole"
  assume_role_policy = data.aws_iam_policy_document.instance_cloudtrail_assume_role_policy.json
}

resource "aws_iam_role_policy" "cloudtrail_policy" {
  name   = "RootUserUsageRolePolicy"
  role   = aws_iam_role.cloudtrail_role.id
  policy = data.aws_iam_policy_document.cloudtrail_role_policy.json
}


data "aws_iam_policy_document" "cloudtrail_role_policy" {
  statement {
    sid       = "AWSCloudTrailCreateLogStream"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.cloudtrail_rootuseralarmgroup.arn}:log-stream:*"]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.cloudtrail_rootuseralarmgroup.arn}:log-stream:*"]
  }
}


data "aws_iam_policy_document" "instance_cloudtrail_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}
