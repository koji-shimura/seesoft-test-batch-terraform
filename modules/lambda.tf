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
      SLACK_WEBHOOK_URL = var.configs.lambda.slack_webhook_url
      ENVIRONMENT       = var.configs.lambda.environment_in_post_message
    }
  }
}
