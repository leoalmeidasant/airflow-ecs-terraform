terraform {
  backend "s3" {
    key    = "data/efs"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "network/sg/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_efs_file_system" "airflow_efs" {
  creation_token = "efs-airflow"

  tags = {
    Name = "Airflow BI-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "EFS - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}

resource "aws_efs_mount_target" "airflow_mount" {
  file_system_id  = aws_efs_file_system.airflow_efs.id
  subnet_id       = element(split(",", data.terraform_remote_state.vpc.outputs.private_subnets), 0)
  security_groups = [data.terraform_remote_state.sg.outputs.efs_security_group_id]
}