source .env

cd network/vpc/
terraform destroy

cd ../../network/security-groups/
terraform destroy

source .env
cd ../../monitoring/cloudwatch/
terraform destroy

source .env
cd data/ecr/
terraform destroy

cd ../../data/ecs/
terraform destroy

cd ../../data/efs/
terraform destroy

cd ../../data/redis/
terraform destroy

cd ../../data/rds/
terraform destroy