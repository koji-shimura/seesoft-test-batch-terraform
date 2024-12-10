### IAM CI role
resource "aws_iam_role" "ci" {
  name               = "${var.project}-github-actions"
  assume_role_policy = data.template_file.ci_assume_policy
  tags               = var.project
}

### IAM CI policy
resource "aws_iam_policy" "ci" {
  name        = "${var.project}-github-actions"
  path        = "/"
  description = "${var.project}-github-actions"
  policy      = data.template_file.ci_policy
}

### IAM CI policy attach
resource "aws_iam_role_policy_attachment" "ci" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci.arn
}
