
resource "aws_ecs_cluster" "main" {
  name = "challenge-ecs-cluster-"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "challenge-ecs-task-"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "challenge-node-container"
    image     = "072834578119.dkr.ecr.us-east-1.amazonaws.com/frontend:v0.10.0"
    essential = true
    enviroment = [{
      RDS_HOSTNAME = "${aws_db_instance.challenge_dbi.endpoint}"
      RDS_USERNAME = "postgresAdmin"
      RDS_PASSWORD = "xstrongDrSp"
      RDS_PORT     = "5432"
      RDS_DATABASE = "test_ead"
    }]
    portMappings = [{
      //protocol      = "tcp"
      containerPort = 3000
      hostPort = 3000
    }]
  }])
}

resource "aws_ecs_service" "main" {
  name                               = "challenge-ecs-service-"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private_subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = "challenge-node-container"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  depends_on = [ 
    aws_alb_listener.http,
    aws_db_instance.challenge_dbi
  ]
}



