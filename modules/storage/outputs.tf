output "input_bucket_name" {
  description = "S3 bucket for uploading text files"
  value       = aws_s3_bucket.input_bucket.bucket
}

output "output_bucket_name" {
  description = "S3 bucket where MP3 files are stored"
  value       = aws_s3_bucket.output_bucket.bucket
}

output "input_bucket_arn" {
  description = "ARN of S3 input bucket"
  value       = aws_s3_bucket.input_bucket.arn
}

output "output_bucket_arn" {
  description = "ARN of S3 output bucket"
  value       = aws_s3_bucket.output_bucket.arn
}
