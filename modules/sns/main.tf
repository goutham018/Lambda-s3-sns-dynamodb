
resource "aws_sns_topic" "notifications" {
  name = var.topic_name
}
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notifications.arn
  protocol  = "email"
  endpoint  = var.email_address  # email to receive notifications
}
