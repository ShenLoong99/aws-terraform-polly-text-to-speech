# Data to retrieve current account details
data "aws_caller_identity" "current" {}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "polly-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy
resource "aws_iam_policy" "lambda_policy" {
  name = "polly-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # GetObject from input bucket (no encryption required)
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${var.input_bucket_arn}/*"
        ]
      },
      # PutObject to output bucket (encryption required)
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${var.output_bucket_arn}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-server-side-encryption" : "AES256"
          }
        }
      },
      # Polly Permission
      {
        Effect = "Allow"
        Action = "polly:SynthesizeSpeech"
        # checkov:skip=CKV_AWS_355: Polly is global service without specific resource ARNs
        Resource = "*" # Polly is a global service and often requires "*"
      },
      # Cloudwatch Logs Permission
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*"
      }
    ]
  })
}

# Attach Policy
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Permission for S3 to invoke Lambda
resource "aws_lambda_permission" "s3_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.input_bucket_arn
}
