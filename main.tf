provider "aws" {
  region = "us-east-1"
  
}
module "sns" {
  source        = "./modules/sns"
  topic_name    = "file-upload-notifications"
  email_address = "gouthamr522@gmail.com"  # Change this
}


module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "s3_upload_logs"
}

module "iam" {
  source         = "./modules/iam"
  role_name      = "lambda_exec_role"
  dynamodb_arn   = module.dynamodb.dynamodb_arn
  sns_topic_arn  = module.sns.topic_arn
}

module "lambda" {
  source           = "./modules/lambda"
  lambda_name      = "s3-file-logger"
  lambda_zip       = "./lambda_function.zip"
  lambda_role_arn  = module.iam.lambda_role_arn
  dynamodb_table   = module.dynamodb.table_name
  sns_topic_arn    = module.sns.topic_arn
  bucket_arn       = module.s3.bucket_arn
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "my-upload-bucket-273550"
  lambda_arn  = module.lambda.lambda_arn
}
