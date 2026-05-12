resource "aws_ecr_repository" "ecr_repo" {
  name                 = "eks"
  image_tag_mutability = "MUTABLE"
  
    tags = {
      name = "eks_ecr"
    }
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 14 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 14
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}