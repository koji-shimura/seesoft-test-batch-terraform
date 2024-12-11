### cloudwatch log group
resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.configs.cloudwatch.log.group_name
  retention_in_days = var.configs.cloudwatch.log.retention_in_days
  tags = {
    Name = var.configs.cloudwatch.log.group_name
  }
}
