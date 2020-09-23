resource "aws_ecr_repository" "airflow_repo" {
  name = "airflow-${terraform.workspace}"
}