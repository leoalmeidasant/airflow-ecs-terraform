terraform {
  backend "s3" {
    bucket = "terraform-state-airflow-lele"
    key    = "network/vpc"
    region = "us-east-1"
  }
}