
resource "aws_lambda_function" "file_processor" {
  filename         = var.lambda_zip
  function_name    = var.lambda_name
  role             = var.lambda_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 10
  environment {
    variables = {
      DDB_TABLE     = var.dynamodb_table
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}
