provider "aws" {
    region = "us-east-1"
}
resource "aws_ecs_task_definition" "test-http" {
  family = "test-http"
  container_definitions = jsonencode([
    {
      name      = "test-http"
      image     = "nginx"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
])
}
