resource "aws_cloudwatch_log_group" "airflow" {
  name = "/ecs/airflow"
}

resource "aws_cloudwatch_log_stream" "stream" {
  name           = "ecs"
  log_group_name = aws_cloudwatch_log_group.airflow.name
}