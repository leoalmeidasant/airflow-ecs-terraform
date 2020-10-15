terraform {
  backend "s3" {
    bucket = "terraform-state-leoalmeida"
    key    = "monitoring/cloudwatch"
    region = "us-east-1"
  }
}