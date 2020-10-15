output "webserver_security_group_id" {
  value = module.airflow_webserver_sg.this_security_group_id
}

output "scheduler_security_group_id" {
  value = module.airflow_scheduler_sg.this_security_group_id
}

output "worker_security_group_id" {
  value = module.airflow_worker_sg.this_security_group_id
}

output "flower_security_group_id" {
  value = module.airflow_flower_sg.this_security_group_id
}

output "efs_security_group_id" {
    value = module.airflow_efs_sg.this_security_group_id
}

output "database_security_group_id" {
    value = module.ariflow_db_sg.this_security_group_id
}

output "codebuild_security_group_id" {
    value = module.airflow_codebuild_sg.this_security_group_id
}

output "redis_security_group_id" {
  value = module.ariflow_redis_sg.this_security_group_id
}