resource "aws_ecs_cluster" "airflow" {
  name               = "BI-${terraform.workspace}"
  capacity_providers = ["FARGATE"]
}