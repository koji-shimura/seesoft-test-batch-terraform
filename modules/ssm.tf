resource "aws_ssm_parameter" "slack_webhook_url" {
  name        = var.configs.lambda.slack_webhook_parameter_name
  description = var.configs.lambda.slack_webhook_parameter_name
  tier        = "Standard"
  type        = "SecureString"
  value       = "<It is assumed that this will be set manually from the console>"
  tags = {
    Name = var.configs.lambda.slack_webhook_parameter_name
  }

  lifecycle {
    ignore_changes = [
      value
    ]
  }

}
