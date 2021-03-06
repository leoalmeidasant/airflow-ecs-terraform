terraform {
  backend "s3" {
    key    = "data/rds"
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

data "aws_ssm_parameter" "airflow_database_password" {
  name = "airflow_database_password"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "airflow-database"

  engine            = "postgres"
  engine_version    = "9.6.9"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "airflow"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "airflow"
  password = data.aws_ssm_parameter.airflow_database_password.value

  port     = "5432"

  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.database_security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Name = "Airflow BI-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "RDS - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  subnet_ids = split(",", data.terraform_remote_state.vpc.outputs.private_subnets)
  family = "postgres9.6"
  major_engine_version = "9.6"
  final_snapshot_identifier = "airflow-database"
  deletion_protection = false
  publicly_accessible = false
}