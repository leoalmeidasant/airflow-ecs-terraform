output "airflow_redis_address" {
  value = aws_elasticache_cluster.airflow_redis.cache_nodes.0.address
}