terraform {
  backend "s3" {
    key    = "monitoring/cloudwatch"
    region = "us-east-1"
  }
}

resource "aws_cloudwatch_log_group" "airflow" {
  name = "/ecs/airflow"
  tags = {
    Name = "Airflow BI-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "Cloudwatch LogStream - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}

resource "aws_cloudwatch_log_stream" "stream" {
  name           = "ecs"
  log_group_name = aws_cloudwatch_log_group.airflow.name
}