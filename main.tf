# Local variables
locals {
  common_tags = {
    Project     = "AWS-Polly-TTS"
    Environment = "Prod"
    ManagedBy   = "Terraform"
    Owner       = "ShenLoong"
  }
}

# Module for S3
module "storage" {
  source                  = "./modules/storage"
  s3_lambda_permission_id = module.iam.s3_lambda_permission_id
  polly_lambda_arn        = module.lambda.polly_lambda_arn
  aws_region              = var.aws_region
  default_tags            = local.common_tags
}

# Module for IAM (Permissions, roles, policies)
module "iam" {
  source               = "./modules/iam"
  input_bucket_arn     = module.storage.input_bucket_arn
  output_bucket_arn    = module.storage.output_bucket_arn
  lambda_function_name = module.lambda.lambda_function_name
  aws_region           = var.aws_region
  default_tags         = local.common_tags
}

# Module for Lambda
module "lambda" {
  source             = "./modules/lambda"
  lambda_role_arn    = module.iam.lambda_role_arn
  output_bucket_name = module.storage.output_bucket_name
  aws_region         = var.aws_region
  default_tags       = local.common_tags
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${module.lambda.lambda_function_name}"
  retention_in_days = 7 # optional, auto-delete after N days
}
