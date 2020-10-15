terraform {
  backend "s3" {
    bucket = "terraform-state-leoalmeida"
    key    = "data/rds"
    region = "us-east-1"
  }
}