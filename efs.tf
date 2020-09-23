resource "aws_efs_file_system" "airflow_efs" {
  creation_token = "efs-airflow"

  tags = {
    Name = "EFS to Airflow dags"
  }
}

resource "aws_efs_mount_target" "airflow_mount" {
  file_system_id  = aws_efs_file_system.airflow_efs.id
  subnet_id       = element(tolist(data.aws_subnet_ids.all.ids), 0)
  security_groups = [module.efs_airflow_sg.this_security_group_id]
}

output "efs_file_system_id" {
    value = aws_efs_mount_target.airflow_mount
}