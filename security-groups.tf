module "airflow_webserver_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-webserver-sg-${terraform.workspace}"
  description = "Security group for airflow webserver with custom ports open within VPC, and PostgreSQL"
  vpc_id      = data.aws_vpc.default.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Airflow Webserver port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = var.sg_tags
}

module "airflow_worker_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-worker-sg-${terraform.workspace}"
  description = "Security group for airflow worker with custom ports open within VPC."
  vpc_id      = data.aws_vpc.default.id

  computed_ingress_with_source_security_group_id = [
    {
      from_port   = 8793
      to_port     = 8793
      protocol    = "tcp"
      description = "Worker port for webserver read logs"
      source_security_group_id = module.airflow_webserver_sg.this_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  number_of_computed_ingress_with_source_security_group_id = 1

  tags = var.sg_tags
}

module "airflow_flower_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-flower-sg-${terraform.workspace}"
  description = "Security group for airflow flower with custom ports open within VPC."
  vpc_id      = data.aws_vpc.default.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5555
      to_port     = 5555
      protocol    = "tcp"
      description = "Flower port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = var.sg_tags
}

module "airflow_scheduler_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-scheduler-sg"
  description = "Security group for airflow scheduler with custom ports open within VPC."
  vpc_id      = data.aws_vpc.default.id

  egress_rules = ["all-all"]
  
  tags = var.sg_tags
}

module "ariflow_redis_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-redis-sg-${terraform.workspace}"
  description = "Security group for airflow redis."
  vpc_id      = data.aws_vpc.default.id

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      description              = "Airflow Webserver"
      source_security_group_id = module.airflow_webserver_sg.this_security_group_id
    },
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      description              = "Airflow Worker"
      source_security_group_id = module.airflow_worker_sg.this_security_group_id
    },
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      description              = "Airflow Flower"
      source_security_group_id = module.airflow_flower_sg.this_security_group_id
    },
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      description              = "Airflow Scheduler"
      source_security_group_id = module.airflow_scheduler_sg.this_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  number_of_computed_ingress_with_source_security_group_id = 4

  tags = var.sg_tags
}

module "ariflow_db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-db-sg-${terraform.workspace}"
  description = "Security group for airflow database with custom ports open within VPC, and PostgreSQL"
  vpc_id      = data.aws_vpc.default.id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      description              = "Airflow Webserver"
      source_security_group_id = module.airflow_webserver_sg.this_security_group_id
    },
    {
      rule                     = "postgresql-tcp"
      description              = "Airflow Worker"
      source_security_group_id = module.airflow_worker_sg.this_security_group_id
    },
    {
      rule                     = "postgresql-tcp"
      description              = "Airflow Flower"
      source_security_group_id = module.airflow_flower_sg.this_security_group_id
    },
    {
      rule                     = "postgresql-tcp"
      description              = "Airflow Scheduler"
      source_security_group_id = module.airflow_scheduler_sg.this_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  number_of_computed_ingress_with_source_security_group_id = 4

  tags = var.sg_tags
}

module "airflow_codebuild_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-codebuild-sg"
  description = "Security group for Airflow Codebuild"
  vpc_id      = data.aws_vpc.default.id

  egress_rules = ["all-all"]

  tags = var.sg_tags
}

module "efs_airflow_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "efs-airflow-sg"
  description = "Security group for Airflow EFS"
  vpc_id      = data.aws_vpc.default.id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "NFS"
      description              = "EFS to Airflow"
      source_security_group_id = module.airflow_scheduler_sg.this_security_group_id
    },
    {
      rule                     = "NFS"
      description              = "EFS to codebuild"
      source_security_group_id = module.airflow_codebuild_sg.this_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = var.sg_tags
}

output "webserver-security-group-id" {
  value = module.airflow_webserver_sg.this_security_group_id
}

output "scheduler-security-group-id" {
  value = module.airflow_scheduler_sg.this_security_group_id
}

output "worker-security-group-id" {
  value = module.airflow_worker_sg.this_security_group_id
}

output "flower-security-group-id" {
  value = module.airflow_flower_sg.this_security_group_id
}