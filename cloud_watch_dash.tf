resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "ecs"
  dashboard_body = jsonencode({
    widgets = local.widgets
  })
}

locals {
  widgets = [{
    type   = "metric"
    width  = 18
    height = 6
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/ECS", "CPUUtilization", "ServiceName", "challenge-ecs-service-"  , "ClusterName", "challenge-ecs-cluster-", { color = "#d62728", stat = "Maximum" }],
        [".", "MemoryUtilization", ".", ".", ".", ".", { yAxis = "right", color = "#1f77b4", stat = "Maximum" }]
      ]
      region = "us-east-1",
      annotations = {
        horizontal = [
          {
            color = "#ff9896",
            label = "100% CPU",
            value = 100
          },
          {
            color = "#9edae5",
            label = "100% Memory",
            value = 100,
            yAxis = "right"
          },
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "challenge-ecs-service / challenge-ecs-cluster  "
      period = 300
    }
  }]
}