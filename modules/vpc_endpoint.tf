# VPC Endpoint
#resource "aws_vpc_endpoint" "vpc_endpoints_for_interface" {
#  for_each = {
#    # for ECR
#    ecr_api = {
#      name    = "SS-Test-01.Inter3FargateTest_ep_ecrapi"
#      service = "com.amazonaws.ap-northeast-1.ecr.api"
#    }
#    ecr_dkr = {
#      name    = "SS-Test-01.Inter3FargateTest_ep_ecrdkr"
#      service = "com.amazonaws.ap-northeast-1.ecr.dkr"
#    }
#    log = {
#      name    = "SS-Test-01.Inter3FargateTest_ep_logs"
#      service = "com.amazonaws.ap-northeast-1.logs"
#    }
#    # for ECS
#    ecs_agent = {
#      name    = "SS-Test-01.seesoft-test-batch_ecs-agent"
#      service = "com.amazonaws.ap-northeast-1.ecs-agent"
#    }
#    ecs_tele = {
#      name    = "SS-Test-01.seesoft-test-batch_ecs-telemetry"
#      service = "com.amazonaws.ap-northeast-1.ecs-telemetry"
#    }
#    ecs = {
#      name    = "SS-Test-01.seesoft-test-batch_ecs"
#      service = "com.amazonaws.ap-northeast-1.ecs"
#    }
#    # for Batch
#    batch = {
#      name    = "SS-Test-01.seesoft-test-batch_batch"
#      service = "com.amazonaws.ap-northeast-1.batch"
#    }
#  }
#
#  vpc_id              = var.vpc_id
#  service_name        = each.value.service
#  vpc_endpoint_type   = "Interface"
#  private_dns_enabled = true
#
#  security_group_ids = [
#    aws_security_group.security_groups["end_point"].id
#  ]
#  subnet_ids = [for subnet in data.aws_subnet.private_subnets : subnet.id]
#
#  tags = {
#    Name = each.value.name
#  }
#
#}
#
#resource "aws_vpc_endpoint" "vpc_endpoints_for_gateway" {
#  for_each = {
#    s3 = {
#      name    = "SS-Test-01.Inter3FargateTest_ep_s3"
#      service = "com.amazonaws.ap-northeast-1.s3"
#    }
#    dynamodb = {
#      name    = "SS-Test-01.seesoft-test-batch_dynamodb"
#      service = "com.amazonaws.ap-northeast-1.dynamodb"
#    }
#  }
#
#  vpc_id            = var.vpc_id
#  service_name      = each.value.service
#  vpc_endpoint_type = "Gateway"
#
#  route_table_ids = data.aws_route_tables.route_tables.ids
#
#  tags = {
#    Name = each.value.name
#  }
#
#}
