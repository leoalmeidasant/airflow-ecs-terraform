##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################

#####
# DB
#####
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "airflow-database"

  engine            = "postgres"
  engine_version    = "9.6.9"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "airflow"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "airflow"
  password = var.airflow_database_password

  port     = "5432"

  vpc_security_group_ids = [module.ariflow_db_sg.this_security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "airflow"
    Environment = terraform.workspace
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  subnet_ids = data.aws_subnet_ids.all.ids
  family = "postgres9.6"
  major_engine_version = "9.6"
  final_snapshot_identifier = "airflow-database"
  deletion_protection = false
  publicly_accessible = false
}

output "airflow_database_endpoint" {
  value = module.db.this_db_instance_endpoint
}