resource "aws_ssm_parameter" "slack_webhook_url" {
  name        = "/${var.project}/slack-webhook-url"
  description = "/${var.project}/slack-webhook-url"
  tier        = "Standard"
  type        = "SecureString"
  value       = "<It is assumed that this will be set manually from the console>"
  tags = {
    Name = "/${var.project}/slack-webhook-url"
  }

  lifecycle {
    ignore_changes = [
      value
    ]
  }

}
