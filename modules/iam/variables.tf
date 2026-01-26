variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "default_tags" {
  description = "Extra tags to pass to the provider"
  type        = map(string)
}

variable "input_bucket_arn" {
  description = "ARN of S3 input bucket"
  type        = string
}

variable "output_bucket_arn" {
  description = "ARN of S3 output bucket"
  type        = string
}

variable "lambda_function_name" {
  description = "Text-to-Speech Lambda function"
  type        = string
}
