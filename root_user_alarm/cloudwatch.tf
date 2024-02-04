

resource "aws_cloudwatch_metric_alarm" "root_usage_cw_alarm" {
  alarm_name                = "Root User Used"
  alarm_description         = "This alarm alerts for root user usage"
  metric_name               = "RootUsageActivity"
  namespace                 = "CloudTrailMetrics"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  statistic                 = "Sum"
  evaluation_periods        = 1
  period                    = 300
  threshold                 = 1
  alarm_actions             = [local.sns_topic_arn]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_group" "cloudtrail_rootuseralarmgroup" {
  name              = "RootUserAlarmLogGroup"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_metric_filter" "root_usage_cw_filter" {
  name           = "RootUsageLogFilter"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_rootuseralarmgroup.id

  metric_transformation {
    name          = "RootUsageActivity"
    namespace     = "CloudTrailMetrics"
    value         = "1"
    default_value = "0"
  }
}
