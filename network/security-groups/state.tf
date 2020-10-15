terraform {
  backend "s3" {
    bucket = "terraform-state-leoalmeida"
    key    = "network/sg"
    region = "us-east-1"
  }
}