### Provider
# AWS
provider "aws" {
  region              = local.region
  # SeesoftAWS
  allowed_account_ids = ["119395085688"]

  default_tags {
    tags = {
      project = local.project
    }
  }
}


### Terraform Configuration
### 2021/10/18時点での最新バージョン
terraform {
  required_version = ">= 1.0.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Seesoft"

    workspaces {
      name = "seesoft-test-batch-terraform"
    }
  }
}

data "aws_caller_identity" "current" {}

### locals
locals {
  region  = "ap-northeast-1"
  account_id = data.aws_caller_identity.current.id
  project = "seesoft-test-batch"
  vpc_id  = "vpc-035d8a20033f88aa4" # SS-Test-01
  configs = {
    private_subnets_tagnames = {
      a = "SS-Test-01.private-1a"
      c = "SS-Test-01.private-1c"
      d = "SS-Test-01.private-1d"
    }
    ci = {
      provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/token.actions.githubusercontent.com"
      org_name     = "koji-shimura"
    }
  }
}



### Modules
module "seesoft-test-batch" {
  source = "../../modules"

  region      = local.region
  project     = local.project
  vpc_id      = local.vpc_id
  account_id  = local.account_id
  configs     = local.configs
}
