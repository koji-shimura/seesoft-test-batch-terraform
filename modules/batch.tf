### batch compute environment
resource "aws_batch_compute_environment" "compute_environment" {
  depends_on = [aws_security_group.security_groups, aws_iam_role.roles]

  compute_environment_name = var.project
  type                     = "MANAGED"
  state                    = "ENABLED"
  service_role             = data.aws_iam_role.batch_service_role.arn
  compute_resources {
    type                = "EC2"
    allocation_strategy = "BEST_FIT_PROGRESSIVE"
    min_vcpus           = var.configs.batch.computing_env.min_vcpus
    max_vcpus           = var.configs.batch.computing_env.max_vcpus
    desired_vcpus       = var.configs.batch.computing_env.desired_vcpus
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

### job queue
resource "aws_batch_job_queue" "job_queue" {
  name                 = "${var.project}-queue"
  state                = "ENABLED"
  priority             = 1
  compute_environments = [aws_batch_compute_environment.compute_environment.arn]
  tags = {
    project = var.project
    Name    = "${var.project}-queue"
  }
}

### job definition
resource "aws_batch_job_definition" "job_definition" {
  depends_on = [aws_batch_job_queue.job_queue]

  name                  = "${var.project}-job"
  type                  = "container"
  platform_capabilities = ["EC2"]
  propagate_tags        = true
  retry_strategy {
    attempts = 1
  }
  timeout {
    attempt_duration_seconds = var.configs.batch.job.timeouts
  }
  container_properties = templatefile("${path.module}/json/container.json",
    {
      image = var.configs.batch.job.image,
      role  = aws_iam_role.iam_roles["job"].arn
  })
  tags = {
    project = var.project
    Name    = "${var.project}-job"
  }

  lifecycle {
    ignore_changes = [
      container_properties
    ]
  }
}
