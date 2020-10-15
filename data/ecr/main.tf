resource "aws_ecr_repository" "airflow_ecr_endpoint" {
  name = "airflow-${terraform.workspace}"
  tags = {
      Name = "Airflow BI"
      Environment = "Dev"
      ApplicationRole = "ECR - Airflow Dev"
      Project = "Airflow"
      Squad = "BI"
      Chapter = "BI"
      CostCenter = "BI"
      Confidentiality = "Low"
    }
}