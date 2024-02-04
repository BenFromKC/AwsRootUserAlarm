
### need to figure out if we're using an existing SNS topic and react accordingly

resource "aws_sns_topic" "new_sns_topic" {
  name  = "root-user-cloudwatch-alarm-topic"
  count = var.user_sns_topic == null ? 1 : 0
}

data "aws_sns_topic" "exist_sns_topic" {
  name  = var.user_sns_topic
  count = var.user_sns_topic == null ? 0 : 1
}

resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  topic_arn = local.sns_topic_arn
  protocol  = "email"
  endpoint  = var.user_email
  count     = var.user_sns_topic == null ? 1 : 0
}

locals {
  sns_topic_arn = var.user_sns_topic == null ? "${aws_sns_topic.new_sns_topic.0.arn}" : "${data.aws_sns_topic.exist_sns_topic.0.arn}"
}

