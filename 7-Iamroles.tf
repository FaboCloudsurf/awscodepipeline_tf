#https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html

#EC2 roles

data "aws_caller_identity" "current" {}


resource "aws_iam_role" "catpipeline_A4L_ec2_role_tf1" {
  name = "catpipeline_A4L_ec2_role1"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_policy" "catpipeline_SessionManager_tf1" {
  name        = "catpipeline_SessionManager1"
  description = "My SessionManager policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
)
}


resource "aws_iam_policy_attachment" "catpipeline_SessionManager_attach_tf1" {
  name       = "catpipeline_SessionManager_attachment1"
  roles      = [aws_iam_role.catpipeline_A4L_ec2_role_tf1.name]
  policy_arn = aws_iam_policy.catpipeline_SessionManager_tf1.arn
}



resource "aws_iam_policy" "ec2_ecr_policy_tf1" {
  name        = "ec2_ecr_policy1"
  description = "Allow EC2 to interact with ECR"
  policy = jsonencode({
  "Statement": [
	{
	  "Action": [
		"ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage"
	  ],
	  "Resource": "*",
	  "Effect": "Allow"
	}
  ],
  "Version": "2012-10-17"
},
  )
  }        
   

resource "aws_iam_policy_attachment" "catpipeline_ec2_ecr_policy_attachment_tf1" {
  name       = "catpipeline_ec2_ecr_policy_attachment1"
  roles      = [aws_iam_role.catpipeline_A4L_ec2_role_tf1.name]
  policy_arn = aws_iam_policy.ec2_ecr_policy_tf1.arn
}

resource "aws_iam_instance_profile" "catpipeline_A4L_ec2_profile_tf1" {
  name = "catpipeline_A4L_ec2_profile1"
  role = aws_iam_role.catpipeline_A4L_ec2_role_tf1.name
}

#Codebuild roles

resource "aws_iam_role" "catpipeline_build_service_roletf1" {
  name = var.iam_role

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "codebuild_ecr_policy_tf1" {
  name        = "codebuild_ecr_policy1"
  description = "Allow codebuild to interact with ECR"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Statement": [
	{
	  "Action": [
		"ecr:BatchCheckLayerAvailability",
		"ecr:CompleteLayerUpload",
		"ecr:GetAuthorizationToken",
		"ecr:InitiateLayerUpload",
		"ecr:PutImage",
		"ecr:UploadLayerPart",
    "ecr:DescribeImage",
    "ecr:BatchGetImage",
    "ecr:PullImage",
    "ecr:DescribeRepositories",
    "ecr:DescribeImages",
    "ecr:GetDownloadUrlForLayer",
    "ecr:ListImages",
    "ecr:GetRepositoryPolicy"
	  ],
	  "Resource": "*",
	  "Effect": "Allow"
	},{
	  "Action": [
		"s3:*"
	  ],
	  "Resource": "*",
	  "Effect": "Allow"
	}
  ],
  "Version": "2012-10-17"
},
  )
  }        

resource "aws_iam_policy_attachment" "catpipeline_build_service_ecr_policy_attachmenttf1" {
  name       = "catpipeline_build_service_policy_attachment"
  roles      = [aws_iam_role.catpipeline_build_service_roletf1.name]
  policy_arn = aws_iam_policy.codebuild_ecr_policy_tf1.arn
}

#policy 2

resource "aws_iam_policy" "cloudwatchlogsfullaccess_policy_tf1" {
  name        = "cloudwatchlogsfullaccess_policy1"
  description = "Allow cloudwatchlogsfullaccess to interact with ECR"

policy = jsonencode({"Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogsFullAccess",
            "Effect": "Allow",
            "Action": [
                "logs:*",
                "cloudwatch:GenerateQuery"
            ],
            "Resource": "*"
        }
    ]
}
  )
  }

resource "aws_iam_policy_attachment" "catpipeline_build_service_policy_cloudwatch_attachment_tf1" {
  name       = "catpipeline_build_service_policy_cloudwatch_attachment"
  roles      = [aws_iam_role.catpipeline_build_service_roletf1.name]
  policy_arn = aws_iam_policy.cloudwatchlogsfullaccess_policy_tf1.arn
}

#policy 3

resource "aws_iam_policy" "catpipeline_SecretsManagerReadWrite_policy_tf1" {
  name        = "SecretsManagerReadWrite_policy1"
  description = "Allow SecretsManagerReadWrite to interact with ECR"


policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "BasePermissions",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:*",
                "cloudformation:CreateChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:DescribeStackResource",
                "cloudformation:DescribeStacks",
                "cloudformation:ExecuteChangeSet",
                "docdb-elastic:GetCluster",
                "docdb-elastic:ListClusters",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "kms:DescribeKey",
                "kms:ListAliases",
                "kms:ListKeys",
                "lambda:ListFunctions",
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances",
                "redshift:DescribeClusters",
                "redshift-serverless:ListWorkgroups",
                "redshift-serverless:GetNamespace",
                "tag:GetResources"
            ],
            "Resource": "*"
        },
        {
            "Sid": "LambdaPermissions",
            "Effect": "Allow",
            "Action": [
                "lambda:AddPermission",
                "lambda:CreateFunction",
                "lambda:GetFunction",
                "lambda:InvokeFunction",
                "lambda:UpdateFunctionConfiguration"
            ],
            "Resource": "arn:aws:lambda:*:*:function:SecretsManager*"
        },
        {
            "Sid": "SARPermissions",
            "Effect": "Allow",
            "Action": [
                "serverlessrepo:CreateCloudFormationChangeSet",
                "serverlessrepo:GetApplication"
            ],
            "Resource": "arn:aws:serverlessrepo:*:*:applications/SecretsManager*"
        },
        {
            "Sid": "S3Permissions",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::awsserverlessrepo-changesets*",
                "arn:aws:s3:::secrets-manager-rotation-apps-*/*"
            ]
        }
    ]
}
  )
  }

resource "aws_iam_policy_attachment" "catpipeline_build_service_policy_SecretsManagerReadWrite_attachment_tf1" {
  name       = "catpipeline_build_service_policy_SecretsManagerReadWrite_attachment"
  roles      = [aws_iam_role.catpipeline_build_service_roletf1.name]
  policy_arn = aws_iam_policy.catpipeline_SecretsManagerReadWrite_policy_tf1.arn
}

#codepipeline roles

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipelinerole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "codepipeline.amazonaws.com"
                ]
            }
        }
    ]
})
}

resource "aws_iam_policy" "codepipeline_policy_tf1" {
  name   = "codepipeline_policy1"
  description = "codepipeline policy"
  policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "codepipeline:*",
                "cloudformation:DescribeStacks",
                "cloudformation:ListStacks",
                "cloudformation:ListChangeSets",
                "cloudtrail:DescribeTrails",
                "codebuild:BatchGetProjects",
                "codebuild:CreateProject",
                "codebuild:ListCuratedEnvironmentImages",
                "codebuild:ListProjects",
                "codecommit:ListBranches",
                "codecommit:GetReferences",
                "codecommit:ListRepositories",
                "codedeploy:BatchGetDeploymentGroups",
                "codedeploy:ListApplications",
                "codedeploy:ListDeploymentGroups",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecs:ListClusters",
                "ecs:ListServices",
                "ecs:RegisterTaskDefinition",
                "ecs:DescribeServices",
                "ecs:UpdateService",
                "ecs:RunTask",
                "ecs:StopTask",
                "ecs:ListTasks",
                "ecs:DescribeTasks",
                "ecs:DescribeClusters",
                "ecs:RegisterContainerInstance",
                "ecs:DeregisterContainerInstance",
                "ecs:DescribeContainerInstances",
                "ecs:DescribeTaskDefinition",
                "elasticbeanstalk:DescribeApplications",
                "elasticbeanstalk:DescribeEnvironments",
                "iam:ListRoles",
                "iam:GetRole",
                "lambda:ListFunctions",
                "events:ListRules",
                "events:ListTargetsByRule",
                "events:DescribeRule",
                "opsworks:DescribeApps",
                "opsworks:DescribeLayers",
                "opsworks:DescribeStacks",
                "s3:ListAllMyBuckets",
                "sns:ListTopics",
                "codestar-notifications:ListNotificationRules",
                "codestar-notifications:ListTargets",
                "codestar-notifications:ListTagsforResource",
                "codestar-notifications:ListEventTypes",
                "states:ListStateMachines"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "CodePipelineAuthoringAccess"
        },
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetBucketPolicy",
                "s3:GetBucketVersioning",
                "s3:GetObjectVersion",
                "s3:CreateBucket",
                "s3:PutBucketPolicy"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "CodePipelineArtifactsReadWriteAccess"
        },
        {
            "Action": [
                "codebuild:StartBuild",
                "codebuild:BatchGetBuilds",
                "codebuild:BatchGetProjects",
                "codebuild:CreateProject",
                "codebuild:ListCuratedEnvironmentImages",
                "codebuild:ListProjects",
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "Codebuildstartbuild"
        },
        {
            "Action": [
                "cloudtrail:PutEventSelectors",
                "cloudtrail:CreateTrail",
                "cloudtrail:GetEventSelectors",
                "cloudtrail:StartLogging"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:cloudtrail:*:*:trail/codepipeline-source-trail",
            "Sid": "CodePipelineSourceTrailReadWriteAccess"
        },
        {
            "Action": [
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:iam::*:role/service-role/cwe-role-*"
            ],
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "events.amazonaws.com"
                    ]
                }
            },
            "Sid": "EventsIAMPassRole"
        },
        {
            "Action": [
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "codepipeline.amazonaws.com"
                    ]
                }
            },
            "Sid": "CodePipelineIAMPassRole"
        },
         {
            "Action": [
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": ["arn:aws:iam::${var.aws_account_id}:role/ecs_task_execution_role","arn:aws:iam::${var.aws_account_id}:role/ecs_task_role"]
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            },
            "Sid": "ECSIAMPassRole"
        },
        {
            "Action": [
                "events:PutRule",
                "events:PutTargets",
                "events:DeleteRule",
                "events:DisableRule",
                "events:RemoveTargets"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:events:*:*:rule/codepipeline-*"
            ],
            "Sid": "CodePipelineEventsReadWriteAccess"
        },
        {
            "Sid": "CodeStarNotificationsReadWriteAccess",
            "Effect": "Allow",
            "Action": [
                "codestar-notifications:CreateNotificationRule",
                "codestar-notifications:DescribeNotificationRule",
                "codestar-notifications:UpdateNotificationRule",
                "codestar-notifications:DeleteNotificationRule",
                "codestar-notifications:Subscribe",
                "codestar-notifications:Unsubscribe"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "codestar-notifications:NotificationsForResource": "arn:aws:codepipeline:*"
                }
            }
        },
        {
            "Sid": "CodeStarNotificationsSNSTopicCreateAccess",
            "Effect": "Allow",
            "Action": [
                "sns:CreateTopic",
                "sns:SetTopicAttributes"
            ],
            "Resource": "arn:aws:sns:*:*:codestar-notifications*"
        },
        {
            "Sid": "CodeStarNotificationsChatbotAccess",
            "Effect": "Allow",
            "Action": [
                "chatbot:DescribeSlackChannelConfigurations",
                "chatbot:ListMicrosoftTeamsChannelConfigurations"
            ],
            "Resource": "*"
        },
        {
  "Sid": "CodeStarConnectionsAccess",
  "Effect": "Allow",
  "Action": [
    "codestar-connections:ListConnections",
    "codestar-connections:GetConnection",
    "codestar-connections:CreateConnection",
    "codestar-connections:UseConnection"
  ],
  "Resource": "*"
},{
  "Sid": "ECSDeploymentPermissions",
  "Effect": "Allow",
  "Action": [
    "ecs:RegisterTaskDefinition",
    "ecs:UpdateService",
    "ecs:DescribeServices",
    "ecs:DescribeTaskDefinition"
  ],
  "Resource": "*"
}


    ],
    "Version": "2012-10-17"

    
})
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment_tf1" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy_tf1.arn
  
}


#ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role_tf" {
  name = "ecs_task_execution_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ecs_task_execution_role_policy_tf" {
  name        = "ecs_task_execution_role_policy"
  description = "My ecs_task_execution_role_ policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateLogGroup"
            ],
            "Resource": ["*"]
        }
    ]
}
)
}


resource "aws_iam_policy_attachment" "ecs_task_execution_role_policy_attach_tf1" {
  name       = "catpipeline_SessionManager_attachment1"
  roles      = [aws_iam_role.ecs_task_execution_role_tf.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#ECS task role
resource "aws_iam_role" "ecs_task_role_tf" {
  name = "ecs_task_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ecs_task_role_policy_tf" {
  name        = "ecs_task_role_policy"
  description = "My ecs_task_role_ policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                 "dynamodb:GetItem",
                 "s3:PutObject",
                  "s3:GetObject",
                 "secretsmanager:GetSecretValue"
            ],
            "Resource": "*"
        }
    ]
}
)
}


resource "aws_iam_policy_attachment" "ecs_task_role_policy_attach_tf1" {
  name       = "ecs_task_role_policy_attachment1"
  roles      = [aws_iam_role.ecs_task_role_tf.name]
  policy_arn = aws_iam_policy.ecs_task_role_policy_tf.arn
}


#ecs service role

# resource "aws_iam_role" "ecs_service_execution_role_tf" {
#   name = "ecs_service_execution_role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }


# resource "aws_iam_policy" "ecs_service_role_policy_tf" {
#   name        = "ecs_service_role_policy"
#   description = "My ecs_service_role_ policy"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "ECSTaskManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:AttachNetworkInterface",
#                 "ec2:CreateNetworkInterface",
#                 "ec2:CreateNetworkInterfacePermission",
#                 "ec2:DeleteNetworkInterface",
#                 "ec2:DeleteNetworkInterfacePermission",
#                 "ec2:Describe*",
#                 "ec2:DetachNetworkInterface",
#                 "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#                 "elasticloadbalancing:DeregisterTargets",
#                 "elasticloadbalancing:Describe*",
#                 "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
#                 "elasticloadbalancing:RegisterTargets",
#                 "route53:ChangeResourceRecordSets",
#                 "route53:CreateHealthCheck",
#                 "route53:DeleteHealthCheck",
#                 "route53:Get*",
#                 "route53:List*",
#                 "route53:UpdateHealthCheck",
#                 "servicediscovery:DeregisterInstance",
#                 "servicediscovery:Get*",
#                 "servicediscovery:List*",
#                 "servicediscovery:RegisterInstance",
#                 "servicediscovery:UpdateInstanceCustomHealthStatus"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "AutoScaling",
#             "Effect": "Allow",
#             "Action": [
#                 "autoscaling:Describe*"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "AutoScalingManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "autoscaling:DeletePolicy",
#                 "autoscaling:PutScalingPolicy",
#                 "autoscaling:SetInstanceProtection",
#                 "autoscaling:UpdateAutoScalingGroup",
#                 "autoscaling:PutLifecycleHook",
#                 "autoscaling:DeleteLifecycleHook",
#                 "autoscaling:CompleteLifecycleAction",
#                 "autoscaling:RecordLifecycleActionHeartbeat"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "Null": {
#                     "autoscaling:ResourceTag/AmazonECSManaged": "false"
#                 }
#             }
#         },
#         {
#             "Sid": "AutoScalingPlanManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "autoscaling-plans:CreateScalingPlan",
#                 "autoscaling-plans:DeleteScalingPlan",
#                 "autoscaling-plans:DescribeScalingPlans",
#                 "autoscaling-plans:DescribeScalingPlanResources"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "EventBridge",
#             "Effect": "Allow",
#             "Action": [
#                 "events:DescribeRule",
#                 "events:ListTargetsByRule"
#             ],
#             "Resource": "arn:aws:events:*:*:rule/ecs-managed-*"
#         },
#         {
#             "Sid": "EventBridgeRuleManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "events:PutRule",
#                 "events:PutTargets"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "StringEquals": {
#                     "events:ManagedBy": "ecs.amazonaws.com"
#                 }
#             }
#         },
#         {
#             "Sid": "CWAlarmManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "cloudwatch:DeleteAlarms",
#                 "cloudwatch:DescribeAlarms",
#                 "cloudwatch:PutMetricAlarm"
#             ],
#             "Resource": "arn:aws:cloudwatch:*:*:alarm:*"
#         },
#         {
#             "Sid": "ECSTagging",
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateTags"
#             ],
#             "Resource": "arn:aws:ec2:*:*:network-interface/*"
#         },
#         {
#             "Sid": "CWLogGroupManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogGroup",
#                 "logs:DescribeLogGroups",
#                 "logs:PutRetentionPolicy"
#             ],
#             "Resource": "arn:aws:logs:*:*:log-group:/aws/ecs/*"
#         },
#         {
#             "Sid": "CWLogStreamManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogStream",
#                 "logs:DescribeLogStreams",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": "arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"
#         },
#         {
#             "Sid": "ExecuteCommandSessionManagement",
#             "Effect": "Allow",
#             "Action": [
#                 "ssm:DescribeSessions"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "ExecuteCommand",
#             "Effect": "Allow",
#             "Action": [
#                 "ssm:StartSession"
#             ],
#             "Resource": [
#                 "arn:aws:ecs:*:*:task/*",
#                 "arn:aws:ssm:*:*:document/AmazonECS-ExecuteInteractiveCommand"
#             ]
#         },
#         {
#             "Sid": "CloudMapResourceCreation",
#             "Effect": "Allow",
#             "Action": [
#                 "servicediscovery:CreateHttpNamespace",
#                 "servicediscovery:CreateService"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "ForAllValues:StringEquals": {
#                     "aws:TagKeys": [
#                         "AmazonECSManaged"
#                     ]
#                 }
#             }
#         },
#         {
#             "Sid": "CloudMapResourceTagging",
#             "Effect": "Allow",
#             "Action": "servicediscovery:TagResource",
#             "Resource": "*",
#             "Condition": {
#                 "StringLike": {
#                     "aws:RequestTag/AmazonECSManaged": "*"
#                 }
#             }
#         },
#         {
#             "Sid": "CloudMapResourceDeletion",
#             "Effect": "Allow",
#             "Action": [
#                 "servicediscovery:DeleteService"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "Null": {
#                     "aws:ResourceTag/AmazonECSManaged": "false"
#                 }
#             }
#         },
#         {
#             "Sid": "CloudMapResourceDiscovery",
#             "Effect": "Allow",
#             "Action": [
#                 "servicediscovery:DiscoverInstances",
#                 "servicediscovery:DiscoverInstancesRevision"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# )
# }

# resource "aws_iam_policy_attachment" "ecs_service_role_policy_attach_tf1" {
#   name       = "ecs_service_role_policy_attachment1"
#   roles      = [aws_iam_role.ecs_service_execution_role_tf.name]
#   policy_arn = aws_iam_policy.ecs_service_role_policy_tf.arn
# }

data "aws_iam_role" "ecs_service_linked" {
  name = "AWSServiceRoleForECS"
  
}


#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html

output "rendered_container_definitions" {
  value = aws_ecs_task_definition.ecs_task_definition.container_definitions
}
