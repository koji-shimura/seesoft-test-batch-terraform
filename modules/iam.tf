### IAM CI role
resource "aws_iam_role" "ci" {
  name               = "${var.project}-github-actions"
  assume_role_policy = templatefile(
    "${path.module}/json/ci_assume_policy.json",
    {
      ci_provider_arn = var.configs.ci.provider_arn
      ci_org_name     = var.configs.ci.org_name
      ci_repo_name    = var.project
    }
  )
  tags               = {
    Name = var.project
  }
}

### IAM CI policy
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

### IAM CI policy attach
resource "aws_iam_role_policy_attachment" "ci" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci.arn
}



resource "aws_iam_role" "roles" {
  depends_on = [aws_iam_policy.policies]
  for_each = {
    compute_env = {
      name        = "${var.project}-compute-env-instance-role",
      path        = "/",
      description = "Allows EC2 instances in an ECS cluster to access ECS, as instance-role for the computing-environment of ${local.common_tags.project}.",
      assume_role_policy = templatefile(
        "${path.module}/json/assume_policy.json",
        { service = "ec2.amazonaws.com" }
      )
    }
    #event = {
    #  name        = "${var.project}-cloudwatch-role",
    #  path        = "/service-role/",
    #  description = null,
    #  assume_role_policy = templatefile(
    #    "${path.module}/json/assume_policy.json",
    #    { service = "events.amazonaws.com" }
    #  )
    #}
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
#resource "aws_iam_policy" "policies" {
#  for_each = {
#    event = {
#      name = "${var.project}-cloudwatch-policy",
#      policy = templatefile(
#        "${path.module}/json/events_policy.json",
#        {}
#      )
#    }
#  }
#
#  path   = "/"
#  name   = each.value.name
#  policy = each.value.policy
#  tags = {
#    Name = each.value.name
#  }
#}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  depends_on = [aws_iam_role.roles]
  for_each = {
    compute_env = { policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role" },
    #event      = { policy_arn = aws_iam_policy.policies["event"].arn }
  }

  role       = aws_iam_role.roles[each.key].name
  policy_arn = each.value.policy_arn
}

### iam instance profile
resource "aws_iam_instance_profile" "instance_profiles" {
  depends_on = [aws_iam_role.roles]
  for_each   = toset(["compute_env"])

  role = aws_iam_role.roles[each.value].name
  name = aws_iam_role.roles[each.value].name
}

