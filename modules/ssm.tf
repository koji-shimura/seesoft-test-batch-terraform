resource "aws_ssm_parameter" "slack_webhook_url" {
  name  = "seesoft-test-batch-slack-webhook-url"
  type  = "SecureString"
  value = "<It is assumed that this will be set manually from the console>"
  tags = {
    Name = "seesoft-test-batch-slack-webhook-url"
  }
}
