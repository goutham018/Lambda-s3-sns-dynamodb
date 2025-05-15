
resource "aws_iam_role" "lambda_exec_role" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_secure_policy"
  description = "Lambda access to DynamoDB and SNS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["logs:*"],
        Effect = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = ["dynamodb:PutItem"],
        Effect = "Allow",
        Resource = var.dynamodb_arn
      },
      {
        Action = ["sns:Publish"],
        Effect = "Allow",
        Resource = var.sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
