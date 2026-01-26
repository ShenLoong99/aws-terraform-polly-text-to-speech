variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "default_tags" {
  description = "Extra tags to pass to the provider"
  type        = map(string)
}

variable "lambda_role_arn" {
  description = "ARN of lambda role"
  type        = string
}

variable "output_bucket_name" {
  description = "S3 bucket where MP3 files are stored"
  type        = string
}
