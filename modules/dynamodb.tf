resource "aws_dynamodb_table" "lock_table" {
  attribute {
    name = "key"
    type = "S"
  }
  billing_mode = "PROVISIONED"
  hash_key     = "key"
  name         = var.configs.dynamodb.table_name
  point_in_time_recovery {
    enabled = "false"
  }
  read_capacity  = "2"
  stream_enabled = "false"
  ttl {
    attribute_name = "ttl"
    enabled        = "true"
  }
  write_capacity = "2"
}
