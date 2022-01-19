provider "aws" {
    access_key = "AKIA5WZSHIG5JRQZ4PWS"
    secret_key = "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"
    region = "us-east-1"
}
resource "aws_ecs_task_definition" "test-http" {
  family = "test-http"
  container_definitions = jsonencode([
    {
      name      = "test-http"
      image     = "bakarthi/myapp:v1.0.${BUILD_NUMBER}"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 8080
        }
      ]
    }
])
}
