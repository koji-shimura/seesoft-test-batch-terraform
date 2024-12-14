# Lambda関数
resource "aws_lambda_function" "post_slack" {
  function_name    = "seesoft-test-batch-post-slack"
  filename         = "seesoft-test-batch-post-slack.zip"
  source_code_hash = data.archive_file.seesoft-test-batch-post-slack.output_base64sha256
  role             = aws_iam_role.roles["lambda"].arn
  runtime          = "python3.9"
  handler          = "seesoft-test-batch-post-slack.lambda_handler"
  timeout          = 30
  environment {
    variables = {
      REGION                       = var.region
      SLACK_WEBHOOK_PARAMETER_NAME = var.configs.lambda.slack_webhook_parameter_name
      ENVIRONMENT                  = var.configs.lambda.environment_in_post_message
    }
  }
}

# Lambda関数をEventBridgeルールによって呼び出せるようにするための権限付与
resource "aws_lambda_permission" "to_event_rule" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_slack.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.batch_failed_monitoring.arn
}
