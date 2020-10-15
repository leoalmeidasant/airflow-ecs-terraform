data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-airflow-letrus"
    key    = "network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = "terraform-state-airflow-letrus"
    key    = "network/sg/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_efs_file_system" "airflow_efs" {
  creation_token = "efs-airflow"

  tags = {
    Name = "EFS to Airflow dags"
  }
}

resource "aws_efs_mount_target" "airflow_mount" {
  file_system_id  = aws_efs_file_system.airflow_efs.id
  subnet_id       = element(data.terraform_remote_state.network.private_subnets, 0)
  security_groups = [data.terraform_remote_state.sg.efs_security_group_id]
}