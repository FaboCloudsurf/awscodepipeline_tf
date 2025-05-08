resource "aws_codepipeline" "codepipeline_tf1" {
  name     = "catpipeline1"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_tf1.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      
      configuration = {
        ConnectionArn           = aws_codestarconnections_connection.catpipeline_github_connection_tf1.arn
        #Owner                  = "FaboCloudsurf"
        BranchName              = "main"
        #Repo                   = "catpipeline41125"
        FullRepositoryId        = "FaboCloudsurf/catpipeline41125"
        #OutputArtifactFormat   = "JSON"
        #PollForSourceChanges   = "false"
        #OAuthToken             = var.git_hub_token
        DetectChanges           = "true"


      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "catpipeline_build1"
      }
    }
  }
 stage {
    name = "Deploy"

    action {
      name              = "Deploy"
      category          = "Deploy"
      owner             = "AWS"
      provider          = "ECS"
      input_artifacts  = ["build_output"]
      version           = "1"
      region            = "us-east-1" 
      configuration = {
        #ActionMode     = "REPLACE_ON_FAILURE"
        #Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        FileName        = "imagedefinitions.json"
        #StackName      = "MyStack"
        #TemplatePath   = "build_output::sam-templated.yaml"
        ClusterName     = "allthecatapps"
        ServiceName     = "catpipeline_service"
      }
      run_order = 1
    }
  }
}




# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.


# resource "aws_codepipeline_webhook" "codepipeline_webhook_tf1" {
#   name            = "codepipeline_webhook"
#   authentication  = "GITHUB_HMAC" #Hash-based Message Authentication Code
#   target_action   = "Source"
#   target_pipeline = aws_codepipeline.codepipeline_tf1.name

#   authentication_configuration {
#     secret_token = random_string.web_hook_secret_tf1.result
#   }

#   filter {
#     json_path    = "$.ref"
#     match_equals = "refs/heads/main"
#   }
# }

# resource "random_string" "web_hook_secret_tf1" {
#   length  = 16
#   special = true
# }

# resource "aws_secretsmanager_secret" "web_hook_secret_auth_config_tf1" {
#   name = "codepipeline-${upper(var.environment)}-webhook-secret"

#   tags = {
#     Environment = var.environment
#   }
# }

# resource "aws_secretsmanager_secret_version" "web_hook_secret_auth_value_tf1" {
#   secret_id     = aws_secretsmanager_secret.web_hook_secret_auth_config_tf1.id
#   secret_string = random_string.web_hook_secret_tf1.result
# }


# Wire the CodePipeline webhook into a GitHub repository.
# resource "github_repository_webhook" "github_webhook_tf1" {
#   #repository = data.github_repository.var.git_hub_repository_url.name
#    repository = "FaboCloudsurf/catpipeline41125"

#   configuration {
#     url          = aws_codepipeline_webhook.codepipeline_webhook_tf1.url
#     content_type = "json"
#     insecure_ssl = true
#     secret       = random_string.web_hook_secret_tf1.result
#   }

#   events = ["push"]
# }

data "github_repository" "github_repo_tf1" {
  full_name = "FaboCloudsurf/catpipeline41125"
  #full_name = var.git_hub_repository_url

}

resource "aws_codestarconnections_connection" "catpipeline_github_connection_tf1" {
  name          = "catpipeline_github_connection1"
  provider_type = "GitHub"
}

resource "aws_s3_bucket" "codepipeline_bucket_tf1" {
  bucket = "codepipelinebucket4202025"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_tf1_pab" {
  bucket = aws_s3_bucket.codepipeline_bucket_tf1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

