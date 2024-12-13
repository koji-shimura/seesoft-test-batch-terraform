### Variables
variable "region" {}
variable "project" {}
variable "vpc_id" {}
variable "account_id" {}
variable "configs" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet" "private_subnets" {
  for_each = var.configs.private_subnets_tagnames

  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

# CI(GithubActions)用OpenIDプロバイダ
data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

# ルートテーブル(Gateway型VPCエンドポイント)用
data "aws_route_tables" "route_tables" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = var.configs.route_table_tagnames
  }
}

data "aws_iam_role" "batch_service_role" {
  name = "AWSBatchServiceRole"
}

data "aws_iam_policy" "container_service" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy" "cloudwatch_log" {
  name = "AWSOpsWorksCloudWatchLogs"
}


# Lambda実行用ポリシー
data "aws_iam_policy" "lambda_basic" {
  name = "AWSLambdaBasicExecutionRole"
}



# S3: task-policyが空だとダメなので（使わないけど)S3の権限を付与
data "aws_s3_bucket" "test_bucket" {
  bucket = "test.seesoft.co.jp"
}



# Create Lambda ZIP
data "archive_file" "seesoft-test-batch-post-slack" {  
  type = "zip"  
  source_file = "${path.module}/code/seesoft-test-batch-post-slack.py" 
  output_path = "seesoft-test-batch-post-slack.zip"
}
