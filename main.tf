terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }
  required_version = ">= 0.14.6"
}

provider "aws" {
  region = "us-east-1"
}

module "l3_vpc" {
  source = "./modules/vpc"
  public_subnets = local.public_subnets
  private_subnets = local.private_subnets
  nat_subnet_id = module.l3_vpc.public_subnet_ids[local.nat_subnet_index]
  alb_subnet_ids = module.l3_vpc.public_subnet_ids
  key_name = local.ssh_key
  vpc_cidr = local.vpc_cidr
  default_tags = local.default_tags
}

module "l4_s3" {
  source = "./modules/bucket"
  name = local.media_bucket_name
  default_tags = local.default_tags
}

