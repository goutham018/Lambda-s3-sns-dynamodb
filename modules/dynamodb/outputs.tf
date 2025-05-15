
output "dynamodb_arn" {
  value = aws_dynamodb_table.uploads_log.arn
}

output "table_name" {
  value = aws_dynamodb_table.uploads_log.name
}
