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
  tags               = var.project
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
