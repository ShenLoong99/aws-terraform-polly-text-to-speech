output "lambda_function_name" {
  description = "Text-to-Speech Lambda function"
  value       = aws_lambda_function.polly_lambda.function_name
}

output "polly_lambda_arn" {
  description = "ARN of Text-to-Speech Lambda function"
  value       = aws_lambda_function.polly_lambda.arn
}

output "s3_lambda_permission_id" {
  description = "The ID of the lambda permission to allow S3 invocation"
  value       = aws_lambda_permission.s3_permission.id
}
