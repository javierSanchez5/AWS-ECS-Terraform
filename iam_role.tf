## ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid    = ""
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "iam_policy_create_ecs_task" {
  name   = "ecs-task-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action  = ["logs:CreateLogGroup"]
        Resource = "*"
      }   
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-exec-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json

  inline_policy {
    name = "iam_policy_create_log_group"
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

locals {
  ecs_task_iam_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly",
    "${aws_iam_policy.iam_policy_create_ecs_task.arn}"
  ]
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  count = length(local.ecs_task_iam_policies)
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = local.ecs_task_iam_policies[count.index]

  depends_on = [aws_iam_policy.iam_policy_create_ecs_task]
}
