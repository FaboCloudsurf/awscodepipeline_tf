resource "aws_codebuild_project" "catpipeline_buildtf1" {
  name          = "catpipeline_build1"
  description   = "catpipeline_build description"
  build_timeout = 5
  service_role  = aws_iam_role.catpipeline_build_service_roletf1.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

    

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "catpipeline_ecr_repo_1"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "a4l-codebuild"
      stream_name = "catpipeline"
    }

   
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/FaboCloudsurf/catpipeline41125.git"
    git_clone_depth = 0

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  

  tags = {
    Environment = "Test"
  }
}



