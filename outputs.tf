output "input_bucket_name" {
  description = "S3 bucket for uploading text files"
  value       = module.storage.input_bucket_name
}

output "output_bucket_name" {
  description = "S3 bucket where MP3 files are stored"
  value       = module.storage.output_bucket_name
}

output "lambda_function_name" {
  description = "Text-to-Speech Lambda function"
  value       = module.lambda.lambda_function_name
}
