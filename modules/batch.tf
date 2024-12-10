### batch compute environment
resource "aws_batch_compute_environment" "compute_environment" {
  depends_on = [aws_security_group.security_group, aws_iam_role.iam_role]

  compute_environment_name = var.project
  type                     = "MANAGED"
  state                    = "ENABLED"
  service_role             = data.aws_iam_role.batch_service_role.arn
  compute_resources {
    type                = "EC2"
    allocation_strategy = "BEST_FIT_PROGRESSIVE"
    min_vcpus           = var.configs.batch_computing_env.min_vcpus
    max_vcpus           = var.configs.batch_computing_env.max_vcpus
    desired_vcpus       = var.configs.batch_computing_env.desired_vcpus
    instance_type       = ["optimal"]
    subnets             = [for subnet in data.aws_subnet.private_subnets : subnet.id]
    security_group_ids  = [aws_security_group.security_groups["batch_env"].id]
    instance_role       = aws_iam_instance_profile.instance_profiles["compute_env"].arn
    ec2_configuration {
      image_type = "ECS_AL2023"
    }
  }
  tags = {
    Name = var.project
  }

  lifecycle {
    ignore_changes = [
      compute_resources[0].desired_vcpus
    ]
  }
}
