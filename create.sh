source .env

aws s3 mb s3://${STATE_BUCKET}

echo --------------------- Creating VPC resources ---------------------

cd network/vpc/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out vpc.plan
terraform apply vpc.plan

echo --------------------- Creating Security Group resources ---------------------

cd ../../network/security-groups/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out sg.plan -var "state_bucket=${STATE_BUCKET}"
terraform apply sg.plan

echo --------------------- Creating Log Group Stream resource ---------------------

cd ../../monitoring/cloudwatch/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out cloudwatch.plan
terraform apply cloudwatch.plan

echo --------------------- Creating ECR resource ---------------------

cd ../../data/ecr/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out ecr.plan
terraform apply ecr.plan

echo --------------------- Creating ECS resource ---------------------

cd ../../data/ecs/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out ecs.plan
terraform apply ecs.plan

echo --------------------- Creating EFS resource ---------------------

cd ../../data/efs/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out efs.plan -var "state_bucket=${STATE_BUCKET}"
terraform apply efs.plan

echo --------------------- Creating Redis resource ---------------------

cd ../../data/redis/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out redis.plan -var "state_bucket=${STATE_BUCKET}"
terraform apply redis.plan

echo --------------------- Creating SSM / Parameter Store secrets ---------------------

cd ../../data/ssm/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out ssm.plan \
    -var "airflow_database_password=${DATABASE_PASSWORD}" \
    -var "airflow_email=${AIRFLOW_EMAIL}" \
    -var "airflow_username=${AIRFLOW_USERNAME}" \
    -var "airflow_password=${AIRFLOW_PASSWORD}" \
    -var "fernet_key=${FERNET_KEY}"
terraform apply ssm.plan

echo --------------------- Creating RDS resource ---------------------

cd ../../data/rds/
terraform init -backend-config="bucket=${STATE_BUCKET}"
terraform plan -out rds.plan -var "state_bucket=${STATE_BUCKET}"
terraform apply rds.plan