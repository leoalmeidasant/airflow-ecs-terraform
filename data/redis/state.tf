terraform {
  backend "s3" {
    bucket = "terraform-state-airflow-letrus"
    key    = "data/redis"
    region = "us-east-1"
  }
}