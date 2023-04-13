terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "default"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id[0]
}

# module "rds" {
#   source = "./modules/rds"
# }

module "lb" {
  source = "./modules/lb"
  subnet_id = module.vpc.public_subnet_id
  security_group = module.ec2.security_group_id
  vpc_id = module.vpc.vpc_id
  instance_id = module.ec2.ec2_id
}

# resource "aws_instance" "Machine-1" {
#   ami           = "ami-007855ac798b5175e" 
#   instance_type = "t2.micro" 
#   key_name      = "rskey" 
#   tags = {
#     Name = "Machine-1"
#   }
# }

