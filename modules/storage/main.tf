# Data to retrieve current account details
data "aws_caller_identity" "current" {}

# Create S3 Buckets (Input & Output)
resource "aws_s3_bucket" "input_bucket" {
  bucket        = "polly-input-bucket-${random_id.suffix.hex}"
  force_destroy = true # demo purpose
}

resource "aws_s3_bucket" "output_bucket" {
  bucket        = "polly-output-bucket-${random_id.suffix.hex}"
  force_destroy = true # demo purpose
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Enable S3 Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "input_enc" {
  bucket = aws_s3_bucket.input_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "output_enc" {
  bucket = aws_s3_bucket.output_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Lifecycle Rule (Cost Control)
resource "aws_s3_bucket_lifecycle_configuration" "input_lifecycle" {
  bucket = aws_s3_bucket.input_bucket.id
  rule {
    id     = "delete-all-audio-after-30-days"
    status = "Enabled"

    filter {} # applies to all objects

    expiration {
      days = 30
    }

    # Abort failed uploads after 7 days to save money
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    # Example 2: If you enabled versioning, delete non-current versions after 7 days
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_input_bucket" {
  bucket = aws_s3_bucket.input_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "output_lifecycle" {
  bucket = aws_s3_bucket.output_bucket.id
  rule {
    id     = "delete-all-audio-after-30-days"
    status = "Enabled"

    filter {} # applies to all objects

    expiration {
      days = 30
    }

    # Abort failed uploads after 7 days to save money
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    # Example 2: If you enabled versioning, delete non-current versions after 7 days
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_output_bucket" {
  bucket = aws_s3_bucket.output_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "input_bucket_access" {
  bucket = aws_s3_bucket.input_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "output_bucket_access" {
  bucket = aws_s3_bucket.output_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
          "${aws_s3_bucket.input_bucket.arn}/*"
        ]
      },
      # PutObject to output bucket (encryption required)
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.output_bucket.arn}/*"
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

# Attach Policy
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
