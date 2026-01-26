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

# S3 Notification
resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = aws_s3_bucket.input_bucket.id

  lambda_function {
    lambda_function_arn = var.polly_lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [var.s3_lambda_permission_id]
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
