### Variables
variable "region" {}
variable "project" {}
variable "vpc_id" {}
variable "account_id" {}
variable "configs" {}

data "aws_iam_role" "batch_service_role" {
  name = "AWSBatchServiceRole"
}

