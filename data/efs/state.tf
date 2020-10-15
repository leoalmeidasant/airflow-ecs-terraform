terraform {
  backend "s3" {
    bucket = "terraform-state-leoalmeida"
    key    = "data/efs"
    region = "us-east-1"
  }
}