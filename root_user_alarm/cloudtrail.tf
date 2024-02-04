resource "aws_cloudtrail" "root_user_usage" {
  name                          = "root_user_usage"
  s3_bucket_name                = local.bucketname
  s3_key_prefix                 = var.key_prefix
  include_global_service_events = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_rootuseralarmgroup.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
}

