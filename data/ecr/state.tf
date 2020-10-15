terraform {
  backend "s3" {
    bucket = "terraform-state-airflow-letrus"
    key    = "data/ecr"
    region = "us-east-1"
  }
}