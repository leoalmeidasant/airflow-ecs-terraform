terraform {
  backend "s3" {
    key    = "data/redis"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "network/sg/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_elasticache_subnet_group" "airflow_redis_subnet_group" {
  name       = "tf-redis-subnet-group"
  subnet_ids = split(",", data.terraform_remote_state.vpc.outputs.private_subnets)
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
  security_group_ids   = [data.terraform_remote_state.sg.outputs.redis_security_group_id]

  tags = {
    Name = "Airflow BI-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "Redis - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}