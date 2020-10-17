terraform {
  backend "s3" {
    key    = "data/ecs"
    region = "us-east-1"
  }
}

resource "aws_ecs_cluster" "airflow" {
  name               = "BI-${terraform.workspace}"
  capacity_providers = ["FARGATE"]
  tags = {
    Name = "Airflow BI-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "ECR - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}