# Module for S3
module "storage" {
  source               = "./modules/storage"
  aws_region           = var.aws_region
  lambda_function_name = module.lambda.lambda_function_name
}

# Module for Polly Lambda
module "lambda" {
  source             = "./modules/lambda"
  lambda_role_arn    = module.storage.lambda_role_arn
  output_bucket_name = module.storage.output_bucket_name
  input_bucket_arn   = module.storage.input_bucket_arn
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${module.lambda.lambda_function_name}"
  retention_in_days = 7 # optional, auto-delete after N days
}

# S3 Notification
# Placed in root to avoid circular dependency
resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = module.storage.input_bucket_id

  lambda_function {
    lambda_function_arn = module.lambda.polly_lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [module.lambda.s3_lambda_permission_id]
}
