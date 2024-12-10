### Variables
variable "region" {}
variable "project" {}
variable "vpc_id" {}
variable "account_id" {}
variable "configs" {}

data "template_file" "ci_assume_policy" {
  template = file("${path.module}/json/ci_assume_policy.json")

  vars = {
    ci_provider_arn = var.configs.ci.provider_arn
    ci_org_name     = var.configs.org_name
    ci_repo_name    = var.project
  }
}

data "template_file" "ci_policy" {
  template = file("${path.module}/json/ci_policy.json")
  vars = {
    ecr_arn = aws_ecr_repository.ecr_repository.arn
  }
}

data "aws_iam_role" "batch_service_role" {
  name = "AWSBatchServiceRole"
}

