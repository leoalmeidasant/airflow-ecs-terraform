source .env
cd network/vpc/
terraform init
terraform plan -out vpc.plan

cd ../../network/security-groups/
terraform init
terraform plan -out sg.plan

cd ../../monitoring/cloudwatch/
terraform init
terraform plan -out cloudwatch.plan

cd ../../data/ecr/
terraform init
terraform plan -out ecr.plan

cd ../../data/ecs/
terraform init
terraform plan -out ecs.plan

cd ../../data/efs/
terraform init
terraform plan -out efs.plan

cd ../../data/redis/
terraform init
terraform plan -out redis.plan

cd ../../data/rds/
terraform init
terraform plan -out rds.plan

cd ../../
#terraform apply ./network/vpc/vpc.plan
#terraform apply ./network/security-groups/sg.plan
#terraform apply ./monitoring/cloudwatch/cloudwatch.plan
#terraform apply ./data/ecr/ecr.plan
#terraform apply ./data/ecs/ecs.plan
#terraform apply ./data/efs/efs.plan
#terraform apply ./data/redis/redis.plan
#terraform apply ./data/rds/redis.plan