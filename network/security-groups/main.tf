data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-leoalmeida"
    key    = "network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

module "airflow_webserver_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-webserver-sg-${terraform.workspace}"
  description = "Security group for airflow webserver with custom ports open within VPC, and PostgreSQL"
  vpc_id      = data.terraform_remote_state.network.vpc_id

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
  vpc_id      = data.terraform_remote_state.network.vpc_id

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
  vpc_id      = data.terraform_remote_state.network.vpc_id

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
  vpc_id      = data.terraform_remote_state.network.vpc_id

  egress_rules = ["all-all"]
  
  tags = var.sg_tags
}

module "ariflow_redis_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-redis-sg-${terraform.workspace}"
  description = "Security group for airflow redis."
  vpc_id      = data.terraform_remote_state.network.vpc_id

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
  vpc_id      = data.terraform_remote_state.network.vpc_id

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
  vpc_id      = data.terraform_remote_state.network.vpc_id

  egress_rules = ["all-all"]

  tags = var.sg_tags
}

module "ariflow_efs_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "airflow-dags-efs-sg-${terraform.workspace}"
  description = "Security group airflow dags efs."
  vpc_id      = data.terraform_remote_state.network.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      description              = "Airflow Webserver"
      source_security_group_id = module.airflow_webserver_sg.this_security_group_id
    },
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      description              = "Airflow Scheduler"
      source_security_group_id = module.airflow_scheduler_sg.this_security_group_id
    },
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      description              = "Airflow Codebuild"
      source_security_group_id = module.airflow_codebuild_sg.this_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  number_of_computed_ingress_with_source_security_group_id = 3

  depends_on   = [module.airflow_webserver_sg, module.airflow_codebuild_sg, module.airflow_scheduler_sg]
  tags = var.sg_tags
}