terraform {
  backend "s3" {
    bucket = "terraform-state-airflow-letrus"
    key    = "data/ecs"
    region = "us-east-1"
  }
}