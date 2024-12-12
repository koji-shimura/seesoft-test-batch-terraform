#################################################################################################
# role and policy for CI(GithubActions)
#################################################################################################
resource "aws_iam_role" "ci" {
  name               = "${var.project}-github-actions"
  assume_role_policy = templatefile(
    "${path.module}/json/ci_assume_policy.json",
    {
      ci_provider_arn = data.aws_iam_openid_connect_provider.github_actions.arn
      ci_org_name     = var.configs.ci.org_name
      ci_repo_name    = var.project
    }
  )
  tags               = {
    Name = var.project
  }
}
resource "aws_iam_policy" "ci" {
  name        = "${var.project}-github-actions"
  path        = "/"
  description = "${var.project}-github-actions"
  policy      = templatefile(
    "${path.module}/json/ci_policy.json",
    {
      ecr_arn = aws_ecr_repository.ecr_repository.arn
    }
  )
}
resource "aws_iam_role_policy_attachment" "ci" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci.arn
}


#################################################################################################
# role and policy for Computing Environment, Job Definition
#################################################################################################
resource "aws_iam_role" "roles" {
  for_each = {
    compute_env = {
      name        = "${var.project}-compute-env-instance-role",
      path        = "/",
      description = "Allows EC2 instances in an ECS cluster to access ECS, as instance-role for the computing-environment of ${var.project}.",
      assume_role_policy = templatefile(
        "${path.module}/json/assume_policy.json",
        { service = "ec2.amazonaws.com" }
      )
    }
    job = {
      name        = "${var.project}-job-role",
      path        = "/",
      description = "Allows EC2 instances in an ECS cluster to access ECS, as instance-role for the job of ${var.project}.",
      assume_role_policy = templatefile(
        "${path.module}/json/assume_policy.json",
        { service = "ecs-tasks.amazonaws.com" }
      )
    }
    lambda = {
      name        = "${var.project}-monitoring-lambda-role",
      path        = "/",
      description = "Allows Lambda to access ECS Task for the job of ${var.project}.",
      assume_role_policy = templatefile(
        "${path.module}/json/assume_policy.json",
        { service = "lambda.amazonaws.com" }
      )
    }
  }

  name                 = each.value.name
  assume_role_policy   = each.value.assume_role_policy
  description          = each.value.description
  path                 = each.value.path
  max_session_duration = 3600
  tags = {
    Name = each.value.name
  }
}

### iam policy
resource "aws_iam_policy" "policies" {
  for_each = {
    job = {
      name = "${var.project}-task-policy",
      policy = templatefile(
        "${path.module}/json/task_policy.json",
        {
          bucket_arn = data.aws_s3_bucket.test_bucket.arn
        }
      )
    }
    #event = {
    #  name = "${var.project}-cloudwatch-policy",
    #  policy = templatefile(
    #    "${path.module}/json/events_policy.json",
    #    {}
    #  )
    #}
  }

  path   = "/"
  name   = each.value.name
  policy = each.value.policy
  tags = {
    Name = each.value.name
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  depends_on = [aws_iam_role.roles, aws_iam_policy.policies]
  for_each = {
    compute_env = {
      role_name = aws_iam_role.roles["compute_env"].name,
      policy_arn = data.aws_iam_policy.container_service.arn
    }
    job = {
      role_name = aws_iam_role.roles["job"].name,
      policy_arn = aws_iam_policy.policies["job"].arn
    }
    job2 = {
      role_name = aws_iam_role.roles["job"].name,
      policy_arn = data.aws_iam_policy.cloudwatch_log.arn
    }
    lambda = {
      role_name = aws_iam_role.roles["lambda"].name,
      policy_arn = data.aws_iam_policy.lambda_basic.arn
    }
  }

  role       = each.value.role_name
  policy_arn = each.value.policy_arn
}

### iam instance profile
resource "aws_iam_instance_profile" "instance_profiles" {
  depends_on = [aws_iam_role.roles]
  for_each   = toset(["compute_env"])

  role = aws_iam_role.roles[each.value].name
  name = aws_iam_role.roles[each.value].name
}

