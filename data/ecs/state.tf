terraform {
  backend "s3" {
    bucket = "terraform-state-leoalmeida"
    key    = "data/ecs"
    region = "us-east-1"
  }
}