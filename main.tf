resource "null_resource" "npm_install" {
  triggers = {
    index = sha256(file("${path.module}/VpcSubnetIpMonitor/index.js"))
  }
  provisioner "local-exec" {
    command = "cd ${path.module}/VpcSubnetIpMonitor && npm install chunk"
  }
}

data "null_data_source" "wait_for_npm_install" {
  inputs = {
    lambda_dependency_id = null_resource.npm_install.id
    source_dir           = "${path.module}/VpcSubnetIpMonitor/"
  }
}
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = data.null_data_source.wait_for_npm_install.outputs["source_dir"]
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "monitoring_lambda" {
  function_name    = var.lambda_function_name
  filename         = data.archive_file.lambda_zip.output_path
  role             = aws_iam_role.monitoring_lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
  memory_size      = 128
  timeout          = var.lambda_invocation_timeout
}


resource "aws_cloudwatch_event_rule" "every_x_minutes" {
  name                = "every-${var.lambda_invocation_rate_minutes}-minutes"
  description         = "Fires every ${var.lambda_invocation_rate_minutes} minutes"
  schedule_expression = "rate(${var.lambda_invocation_rate_minutes} minutes)"
}

resource "aws_cloudwatch_event_target" "check_every_x_minutes" {
  rule      = aws_cloudwatch_event_rule.every_x_minutes.name
  target_id = aws_lambda_function.monitoring_lambda.id
  arn       = aws_lambda_function.monitoring_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_monitoring_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.monitoring_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_x_minutes.arn
}

resource "aws_iam_policy" "vpc_subnet_ip_monitor_execution_policy" {
  name = var.lambda_execution_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeSubnets"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "monitoring_lambda_role_to_vpc_subnet_ip_monitor_execution_policy_attachment" {
  role       = aws_iam_role.monitoring_lambda_role.name
  policy_arn = aws_iam_policy.vpc_subnet_ip_monitor_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "monitoring_lambda_role_to_aws_basic_lambda_execution_attachment" {
  role       = aws_iam_role.monitoring_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "monitoring_lambda_role" {
  name = var.lambda_execution_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
