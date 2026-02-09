variable "lambda_role_arn" {
  description = "ARN of lambda role"
  type        = string
}

variable "output_bucket_name" {
  description = "S3 bucket where MP3 files are stored"
  type        = string
}

variable "input_bucket_arn" {
  description = "ARN of S3 input bucket"
  type        = string
}

variable "lambda_role_id" {
  description = "ID of lambda role"
  type        = string
}
