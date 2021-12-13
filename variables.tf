variable "lambda_function_name" {
  type        = string
  default     = "VpcSubnetIpMonitorFunction"
  description = "The function name for the created lambda"
}

variable "lambda_invocation_rate_minutes" {
  type        = number
  default     = 5
  description = "Fire the lambda every X minutes"
}

variable "lambda_execution_policy_name" {
  type        = string
  default     = "VpcSubnetIpMonitorExecutionPolicy"
  description = "The IAM policy name for the lambda execution permissions"
}

variable "lambda_execution_role_name" {
  type        = string
  default     = "VpcSubnetIpMonitorRole"
  description = "The IAM role name for the lambda execution permissions"
}
variable "lambda_invocation_timeout" {
  type        = number
  description = "The timeout parameter for the lambda invocation"
  default     = 5
}
