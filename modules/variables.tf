### Variables
variable "region" {}
variable "project" {}
variable "vpc_id" {}
variable "account_id" {}
variable "configs" {}

data "aws_subnet" "private_subnets" {
  for_each = var.configs.private_subnets_tagnames

  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

# VPCエンドポイント(Gateway)用
data "aws_route_tables" "route_tables" {
  for_each = var.configs.route_tables_tagnames

  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}


data "aws_iam_role" "batch_service_role" {
  name = "AWSBatchServiceRole"
}

# S3: task-policyが空だとダメなので（使わないけど)S3の権限を付与
data "aws_s3_bucket" "test_bucket" {
  bucket = "test.seesoft.co.jp"
}

# エンドポイント用セキュリティグループ
data "aws_security_group" "endpoint" {
  id = var.configs.security_group_id_for_endpoint
}
