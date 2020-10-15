terraform {
  backend "s3" {
    bucket = "terraform-state-leoalmeida"
    key    = "data/ecr"
    region = "us-east-1"
  }
}