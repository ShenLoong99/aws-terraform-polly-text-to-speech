output "input_bucket_name" {
  description = "S3 bucket for uploading text files"
  value       = aws_s3_bucket.input_bucket.bucket
}

output "output_bucket_name" {
  description = "S3 bucket where MP3 files are stored"
  value       = aws_s3_bucket.output_bucket.bucket
}

output "lambda_role_arn" {
  description = "ARN of lambda role"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_role_id" {
  description = "ID of lambda role"
  value       = aws_iam_role.lambda_role.id
}

output "input_bucket_id" {
  description = "ID of the input S3 bucket"
  value       = aws_s3_bucket.input_bucket.id
}

output "input_bucket_arn" {
  description = "ARN of the input S3 bucket"
  value       = aws_s3_bucket.input_bucket.arn
}
