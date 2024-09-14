provider "aws" {
  region = "us-west-2"
}

# VPC Module
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

# Public Subnets Module
module "public_subnets" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.1.0/24"
  public_subnet = true
}

# Private Subnets Module
module "private_subnets" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.2.0/24"
  public_subnet = false
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(module.public_subnets.subnet_ids, 0) # Use first public subnet
}

# Route Table for Private Subnets with NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Associate Private Subnets with Route Table
resource "aws_route_table_association" "private_subnets" {
  count         = length(module.private_subnets.subnet_ids)
  subnet_id     = element(module.private_subnets.subnet_ids, count.index)
  route_table_id = aws_route_table.private.id
}

# Security Group Module
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

# EC2 Instance Module
module "ec2" {
  source             = "./modules/ec2"
  ami                = "ami-04a81a99f5ec58529" 
  instance_type      = "t2.micro"
  key_name           = "MyKey"
  subnet_id          = element(module.public_subnets.subnet_ids, 0) # Use first public subnet
  security_group_ids = [module.security_group.id]
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"
}

# EKS Module
module "eks" {
  source                 = "./modules/eks"
  eni_subnet_ids         = module.private_subnets.subnet_ids
  nodegroup_subnets_id   = module.private_subnets.subnet_ids
}
