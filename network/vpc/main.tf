terraform {
  backend "s3" {
    key    = "network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_availability_zones" "all" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_vpc

  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.vpc_name}-${terraform.workspace}-sg"
    Environment = "${terraform.workspace}"
    ApplicationRole = "VPC - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(var.cidr_vpc, var.cidr_network_bits, count.index)
  availability_zone       = element(data.aws_availability_zones.all.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private-${element(data.aws_availability_zones.all.names, count.index)}-subnet"
    Environment = "${terraform.workspace}"
    ApplicationRole = "AWS Subnet - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(var.cidr_vpc, var.cidr_network_bits, (count.index + length(split(",", lookup(var.azs, var.region)))))
  availability_zone       = element(data.aws_availability_zones.all.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${element(data.aws_availability_zones.all.names, count.index)}-subnet"
    Environment = "${terraform.workspace}"
    ApplicationRole = "AWS Subnet - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]
  tags = {
    Name = "internet-gateway-${var.vpc_name}-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "AWS Subnet - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}

resource "aws_eip" "nat_gateway_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "elastic-ip-${var.vpc_name}-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "AWS Subnet - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet.*.id[0]
  depends_on    = [aws_internet_gateway.internet_gateway, aws_subnet.public_subnet]
  tags = {
    Name = "nat-gateway-${var.vpc_name}-${terraform.workspace}"
    Environment = "${terraform.workspace}"
    ApplicationRole = "AWS Subnet - Airflow-${terraform.workspace}"
    Project = "Airflow"
    Squad = "BI"
    Chapter = "BI"
    CostCenter = "BI"
    Confidentiality = "Low"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags =  {
    Name = "route_table_public-airflow-${terraform.workspace}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags =  {
    Name = "route_table_private_airflow_${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(split(",", lookup(var.azs, var.region)))
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(split(",", lookup(var.azs, var.region)))
  subnet_id      = element(aws_subnet.private_subnet.*.id,count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "vpc_security_group" {
  name   = "aws-${var.vpc_name}-vpc-sg"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "allow_ssh_internal" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.cidr_vpc]

  security_group_id = aws_security_group.vpc_security_group.id
}

resource "aws_security_group_rule" "egress_allow_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.vpc_security_group.id
}
