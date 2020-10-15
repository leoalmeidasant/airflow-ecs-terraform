output "efs_file_system_id" {
    value = aws_efs_mount_target.airflow_mount.file_system_id
}