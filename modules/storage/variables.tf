variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "default_tags" {
  description = "Extra tags to pass to the provider"
  type        = map(string)
}

variable "polly_lambda_arn" {
  description = "ARN of Text-to-Speech Lambda function"
  type        = string
}

variable "s3_lambda_permission_id" {
  description = "The ID of the lambda permission to allow S3 invocation"
  type        = string
}
