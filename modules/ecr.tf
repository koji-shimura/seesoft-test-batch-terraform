### ECR
resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.common_tags.project
  image_tag_mutability = "MUTABLE"
}

# LifeCycle for ECR
resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  repository = aws_ecr_repository.ecr_repository.name

  policy = <<EOF
{
    "rules" : [
        {
            "rulePriority": 1,
            "description": "Save only 3 recent images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

}
