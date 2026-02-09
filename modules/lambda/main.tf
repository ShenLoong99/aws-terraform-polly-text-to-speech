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

  tracing_config {
    mode = "Active"
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }

  environment {
    variables = {
      OUTPUT_BUCKET = var.output_bucket_name
    }
  }
}

# Permission for S3 to invoke Lambda
resource "aws_lambda_permission" "s3_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.polly_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.input_bucket_arn
}

# Create the SQS Queue to act as the DLQ
resource "aws_sqs_queue" "lambda_dlq" {
  name                      = "polly-lambda-dlq"
  message_retention_seconds = 1209600 # 14 days

  # Encryption at rest (Security Pillar best practice)
  sqs_managed_sse_enabled = true
}

# Grant Lambda permission to send messages to the SQS DLQ
resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name = "LambdaDLQPolicy"
  role = var.lambda_role_id # Ensure your module passes the role ID

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sqs:SendMessage"
        Effect   = "Allow"
        Resource = aws_sqs_queue.lambda_dlq.arn
      }
    ]
  })
}
