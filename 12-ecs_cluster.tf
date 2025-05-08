resource "aws_ecs_cluster" "allthecatapps_tf" {
  name = "allthecatapps"
  
  
  
}
  
resource "aws_ecs_task_definition" "ecs_task_definition" {
  
 family                   = "catpipelinedemo"
 network_mode             = "awsvpc"
 execution_role_arn       = aws_iam_role.ecs_task_execution_role_tf.arn
 task_role_arn            = aws_iam_role.ecs_task_role_tf.arn
 cpu                      =  512
 memory                   =  1024
 requires_compatibilities = ["FARGATE"]
 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }
 container_definitions = jsonencode([
   {
     name      = "catpipeline"
     image     = "${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/catpipeline_ecr_repo_1:latest"
     cpu                      = 512
     memory                   = 1024
     essential = true
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
         port_mapping_name = "catpipeline_80_tcp"
       }
     ]
    
    #  environment = [
    #    {
    #      name  = "ENV_VAR_NAME"
    #      value = "ENV_VAR_VALUE"
    #    }
    #    ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.catpipeline_logs_tf.name}"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
          #awslogs-create-group  = "true"
          
        }
      }

      
      # environment = [
      #   {
      #     name  = "ENV_VAR_NAME"
      #     value = "ENV_VAR_VALUE"
      #   }
      # ]
    }
  ])
}     

resource "aws_cloudwatch_log_group" "catpipeline_logs_tf" {
  name = "/ecs/catpipeline"
  retention_in_days = 7
}
#creat service

resource "aws_ecs_service" "catpipeline_service_tf" {
  name                              = "catpipeline_service"
  cluster                           = aws_ecs_cluster.allthecatapps_tf.id
  force_new_deployment              = true
  task_definition                   = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count                     = "2"
  #iam_role                          = aws_iam_role.ecs_task_execution_role_tf.arn
  depends_on                        = [aws_lb_listener.listener_tf1]
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"  #service type in console
  deployment_maximum_percent        = 200
  deployment_minimum_healthy_percent = 100
  platform_version                  = "1.4.0"
  deployment_controller {
    type = "ECS"
  }
  #deplyment type in console
  network_configuration {
    subnets          = [aws_subnet.public_a.id, 
                        aws_subnet.public_b.id, 
                        aws_subnet.public_c.id, 
                        aws_subnet.public_d.id, 
                        aws_subnet.public_e.id, 
                        aws_subnet.public_f.id]
    security_groups  = tolist([aws_security_group.catpipeline_sg_tf2.id,
                         var.default_security_group])
    assign_public_ip = true
  }

  

  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "cpu"
  # }

  load_balancer {
    target_group_arn = aws_lb_target_group.catpipelineA_tg_tf1.arn
    container_name   = "catpipeline"
    container_port   = 80
    
  }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}
   
data "aws_security_group" "security_group_default_tf1" {
  id = var.default_security_group
  vpc_id = aws_default_vpc.default.id
}




