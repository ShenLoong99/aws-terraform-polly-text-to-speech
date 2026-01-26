# Use Terraform archive_file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = "${path.module}/lambda/function.zip"
}

# Lambda Deployment via Terraform
resource "aws_lambda_function" "polly_lambda" {
  function_name = "polly-text-to-speech"

  runtime          = "python3.11"
  handler          = "handler.lambda_handler"
  role             = var.lambda_role_arn
  timeout          = 10  # Lambda Timeout Explicitly Set
  memory_size      = 256 # Lambda Memory Explicitly Set
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # Enable X-Ray Tracing for the Lambda function
  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      OUTPUT_BUCKET = var.output_bucket_name
    }
  }
}
