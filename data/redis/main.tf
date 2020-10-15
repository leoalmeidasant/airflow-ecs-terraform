data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-leoalmeida"
    key    = "network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = "terraform-state-leoalmeida"
    key    = "network/sg/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_elasticache_subnet_group" "airflow_redis_subnet_group" {
  name       = "tf-redis-subnet-group"
  subnet_ids = data.terraform_remote_state.network.private_subnets
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
  security_group_ids   = [data.terraform_remote_state.sg.redis_security_group_id]

  tags = {
    Project = "Airflow ECS"
  }
}