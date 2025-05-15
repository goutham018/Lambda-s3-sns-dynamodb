
resource "aws_sns_topic" "notifications" {
  name = var.topic_name
}
