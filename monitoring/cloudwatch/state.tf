terraform {
  backend "s3" {
    bucket = "terraform-state-airflow-letrus"
    key    = "monitoring/cloudwatch"
    region = "us-east-1"
  }
}