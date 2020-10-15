terraform {
  backend "s3" {
    bucket = "terraform-state-airflow-letrus"
    key    = "data/efs"
    region = "us-east-1"
  }
}