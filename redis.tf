resource "aws_elasticache_subnet_group" "airflow_redis_subnet_group" {
  name       = "tf-redis-subnet-group"
  subnet_ids = data.aws_subnet_ids.all.ids
}

resource "aws_elasticache_cluster" "airflow_redis" {
  cluster_id           = "airflow-redis"
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.airflow_redis_subnet_group.name
  security_group_ids   = [module.ariflow_redis_sg.this_security_group_id]

  tags = {
    Project = "Airflow ECS"
  }
}

output "airflow_redis_address" {
  value = aws_elasticache_cluster.airflow_redis.cache_nodes.0.address
}