output "lambda_function_name" {
  description = "Text-to-Speech Lambda function"
  value       = aws_lambda_function.polly_lambda.function_name
}

output "polly_lambda_arn" {
  description = "ARN of Text-to-Speech Lambda function"
  value       = aws_lambda_function.polly_lambda.arn
}
