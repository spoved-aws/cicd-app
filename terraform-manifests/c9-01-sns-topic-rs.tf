resource "aws_sns_topic" "spoved_vprofile_notification" {
  name = "spoved-vprofile-notification"
}

resource "aws_sns_topic_subscription" "vprofile_email_subscription" {
  topic_arn = aws_sns_topic.spoved_vprofile_notification.arn
  protocol  = "email"
  endpoint  = "kanukhosla10@gmail.com"
}
