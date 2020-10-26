output "airflow_ecr_endpoint" {
    value = aws_ecr_repository.airflow_ecr_endpoint.repository_url
}

output "airflow_ecr_name" {
    value = split("/", aws_ecr_repository.airflow_ecr_endpoint.repository_url)[1]
}