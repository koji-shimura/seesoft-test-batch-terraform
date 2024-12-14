## EventBridge rule
resource "aws_cloudwatch_event_rule" "batch_failed_monitoring" {
  name        = "${var.project_id}-batch-failed-monitoring"
  description = "Capture each Batch job state change to FAILED"

  event_pattern = jsonencode({
    "source": ["aws.batch"],
    "detail-type": ["Batch Job State Change"],
    "detail": {
      "jobName": [{
        "wildcard": "seesoft-*-job"
      }],
      "status": ["FAILED"]
    }
  })

  tags = {
    Name = "${var.project_id}-event-monitoring"
  }

}

## EventBridge event target
resource "aws_cloudwatch_event_target" "post_slack_lambda" {
  rule = aws_cloudwatch_event_rule.batch_failed_monitoring.name
  arn  = aws_lambda_function.post_slack.arn
}
