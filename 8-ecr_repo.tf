# This file contains the ECR repository resource 

resource "aws_ecr_repository" "catpipeline_ecr_repo_tf1" {
  name                 = "catpipeline_ecr_repo_1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

