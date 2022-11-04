resource "aws_ecs_cluster" "main" {
  name = "challenge-ecs-cluster-"
}

data "template_file" "app" {
  template = file("task_definition.json")

  vars = {
   dbendpoint = aws_db_instance.challenge_dbi.address
   username = "postgresAdmin"
   pass = "xstrrngDrSp"
   port = "5432"
   dbname = "test_ead"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "challenge-ecs-task-"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = data.template_file.app.rendered
}

resource "aws_ecs_service" "main" {
  name                               = "ECS_SERVICE"
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
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = "challenge-node-container"
    container_port   = 3000
  }


  depends_on = [ 
    aws_alb_listener.http,
    aws_db_instance.challenge_dbi
  ]
}
