
resource "aws_dynamodb_table" "uploads_log" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "FileName"

  attribute {
    name = "FileName"
    type = "S"
  }
}
