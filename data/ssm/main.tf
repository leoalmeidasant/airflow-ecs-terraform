terraform {
  backend "s3" {
    key    = "data/ssm"
    region = "us-east-1"
  }
}

resource "aws_ssm_parameter" "airflow_database_username" {
  name  = "airflow_database_username"
  type  = "String"
  value = "airflow"
}

resource "aws_ssm_parameter" "airflow_database_password" {
  name  = "airflow_database_password"
  type  = "String"
  value = var.airflow_database_password
}

resource "aws_ssm_parameter" "airflow_email" {
  name  = "airflow_email"
  type  = "String"
  value = var.airflow_email
}

resource "aws_ssm_parameter" "airflow_username" {
  name  = "airflow_username"
  type  = "String"
  value = var.airflow_username
}

resource "aws_ssm_parameter" "airflow_password" {
  name  = "airflow_password"
  type  = "String"
  value = var.airflow_password
}

resource "aws_ssm_parameter" "fernet_key" {
  name  = "fernet_key"
  type  = "String"
  value = var.fernet_key
}