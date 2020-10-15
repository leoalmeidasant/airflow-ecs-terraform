output "airflow_ecr_endpoint" {
    value = module.aws_ecr_repository.airflow_repo
}