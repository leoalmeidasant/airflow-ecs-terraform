terraform {
  backend "s3" {
    bucket = "terraform-state-airflow-letrus"
    key    = "network/sg"
    region = "us-east-1"
  }
}