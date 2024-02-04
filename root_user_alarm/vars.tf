provider "aws" {
  profile = "your-aws-profile-name"
}

variable "user_email" {
  description = "This is the email that will receive notifications of root userusage"
  type        = string
  default     = "youremail@example.com"
}

variable "user_sns_topic" {
  description = "This variable can be used to use an existing SNS topic for your alerts"
  type        = string
  default     = null
}

variable "key_prefix" {
  description = "s3 key prefix for the cloudtrail"
  type        = string
  default     = "root_user_cloudtrail"
}

