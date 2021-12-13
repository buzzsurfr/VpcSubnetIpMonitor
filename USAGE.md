## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.every_x_minutes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.check_every_x_minutes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.vpc_subnet_ip_monitor_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.monitoring_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.monitoring_lambda_role_to_aws_basic_lambda_execution_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.monitoring_lambda_role_to_vpc_subnet_ip_monitor_execution_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.monitoring_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_monitoring_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [null_resource.npm_install](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [null_data_source.wait_for_npm_install](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_execution_policy_name"></a> [lambda\_execution\_policy\_name](#input\_lambda\_execution\_policy\_name) | The IAM policy name for the lambda execution permissions | `string` | `"VpcSubnetIpMonitorExecutionPolicy"` | no |
| <a name="input_lambda_execution_role_name"></a> [lambda\_execution\_role\_name](#input\_lambda\_execution\_role\_name) | The IAM role name for the lambda execution permissions | `string` | `"VpcSubnetIpMonitorRole"` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | The function name for the created lambda | `string` | `"VpcSubnetIpMonitorFunction"` | no |
| <a name="input_lambda_invocation_rate_minutes"></a> [lambda\_invocation\_rate\_minutes](#input\_lambda\_invocation\_rate\_minutes) | Fire the lambda every X minutes | `number` | `5` | no |
| <a name="input_lambda_invocation_timeout"></a> [lambda\_invocation\_timeout](#input\_lambda\_invocation\_timeout) | The timeout parameter for the lambda invocation | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_monitoring_lambda"></a> [monitoring\_lambda](#output\_monitoring\_lambda) | The aws\_lambda\_function output |
