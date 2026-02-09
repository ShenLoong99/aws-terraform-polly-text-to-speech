<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.lambda_sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.polly_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.s3_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sqs_queue.lambda_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_input_bucket_arn"></a> [input\_bucket\_arn](#input\_input\_bucket\_arn) | ARN of S3 input bucket | `string` | n/a | yes |
| <a name="input_lambda_role_arn"></a> [lambda\_role\_arn](#input\_lambda\_role\_arn) | ARN of lambda role | `string` | n/a | yes |
| <a name="input_lambda_role_id"></a> [lambda\_role\_id](#input\_lambda\_role\_id) | ID of lambda role | `string` | n/a | yes |
| <a name="input_output_bucket_name"></a> [output\_bucket\_name](#input\_output\_bucket\_name) | S3 bucket where MP3 files are stored | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Text-to-Speech Lambda function |
| <a name="output_polly_lambda_arn"></a> [polly\_lambda\_arn](#output\_polly\_lambda\_arn) | ARN of Text-to-Speech Lambda function |
| <a name="output_s3_lambda_permission_id"></a> [s3\_lambda\_permission\_id](#output\_s3\_lambda\_permission\_id) | The ID of the lambda permission to allow S3 invocation |
<!-- END_TF_DOCS -->