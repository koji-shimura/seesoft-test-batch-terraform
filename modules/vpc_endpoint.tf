# VPC Endpoint
resource "aws_vpc_endpoint" "vpc_endpoints_for_interface" {
  for_each = {
    # for ECR
    ecr_api = {
      name                = "SS-Test-01.Inter3FargateTest_ep_ecrapi"
      service             = "com.amazonaws.ap-northeast-1.ecr.api"
      private_dns_enabled = true
    }
    ecr_dkr = {
      name                = "SS-Test-01.Inter3FargateTest_ep_ecrdkr"
      service             = "com.amazonaws.ap-northeast-1.ecr.dkr"
      private_dns_enabled = true
    }
    log = {
      name                = "SS-Test-01.Inter3FargateTest_ep_logs"
      service             = "com.amazonaws.ap-northeast-1.logs"
      private_dns_enabled = true
    }
    # for ECS
    ecs_agent = {
      name                = "SS-Test-01.seesoft-test-batch_ecs-agent"
      service             = "com.amazonaws.ap-northeast-1.ecs-agent"
      private_dns_enabled = true
    }
    ecs_tele = {
      name                = "SS-Test-01.seesoft-test-batch_ecs-telemetry"
      service             = "com.amazonaws.ap-northeast-1.ecs-telemetry"
      private_dns_enabled = true
    }
    ecs = {
      name                = "SS-Test-01.seesoft-test-batch_ecs"
      service             = "com.amazonaws.ap-northeast-1.ecs"
      private_dns_enabled = true
    }
    # for Batch
    batch = {
      name                = "SS-Test-01.seesoft-test-batch_batch"
      service             = "com.amazonaws.ap-northeast-1.batch"
      private_dns_enabled = true
    }
    # for Dynamodb
    dynamodb = {
      name                = "SS-Test-01.seesoft-test-batch_dynamodb"
      service             = "com.amazonaws.ap-northeast-1.dynamodb"
      private_dns_enabled = false
    }
  }

  vpc_id              = var.vpc_id
  service_name        = each.value.service
  vpc_endpoint_type   = "Interface"

  security_group_ids = [
    aws_security_group.security_groups["end_point"].id
  ]

  subnet_ids = [for subnet in data.aws_subnet.private_subnets : subnet.id]

  private_dns_enabled = each.value.private_dns_enabled

  tags = {
    Name = each.value.name
  }

}

resource "aws_vpc_endpoint" "vpc_endpoints_for_gateway" {
  for_each = {
    s3 = {
      name        = "SS-Test-01.Inter3FargateTest_ep_s3"
      service     = "com.amazonaws.ap-northeast-1.s3"
    }
  }

  vpc_id            = var.vpc_id
  service_name      = each.value.service
  vpc_endpoint_type = "Gateway"

  route_table_ids = data.aws_route_tables.route_tables.ids

  tags = {
    Name = each.value.name
  }

}
