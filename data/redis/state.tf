terraform {
  backend "s3" {
    bucket = "terraform-state-leoalmeida"
    key    = "data/redis"
    region = "us-east-1"
  }
}