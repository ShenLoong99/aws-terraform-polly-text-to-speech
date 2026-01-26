output "lambda_role_arn" {
  description = "ARN of lambda role"
  value       = aws_iam_role.lambda_role.arn
}

output "s3_lambda_permission_id" {
  description = "The ID of the lambda permission to allow S3 invocation"
  value       = aws_lambda_permission.s3_permission.id
}
