source .env

cd network/vpc/
rm -rf .terraform
cd ../../network/security-groups/
rm -rf .terraform
cd ../../monitoring/cloudwatch/
rm -rf .terraform
cd ../../data/ecr/
rm -rf .terraform
cd ../../data/ecs/
rm -rf .terraform
cd ../../data/efs/
rm -rf .terraform
cd ../../data/redis/
rm -rf .terraform
cd ../../data/rds/
rm -rf .terraform