resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(var.default_tags, tomap({
    Name = "L4 VPC"
  }))
}

# Public Subnets
module "public_subnets" {
  source = "../subnet"
  vpc_id = aws_vpc.vpc.id
  subnets = var.public_subnets
  default_tags = var.default_tags
}

# Private Subnets
module "private_subnets" {
  source = "../subnet"
  vpc_id = aws_vpc.vpc.id
  subnets = var.private_subnets
  default_tags = var.default_tags
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.default_tags, tomap({
    Name = "L4 IGW"
  }))
}

# Allocate Elastic IP
resource "aws_eip" "eip" {}

# NAT
resource "aws_nat_gateway" "nat" {
  subnet_id = var.nat_subnet_id
  allocation_id = aws_eip.eip.id
  tags = merge(var.default_tags, tomap({
    Name = "L4 NAT"
  }))
}

# Route Tables
module "route_tables" {
  source = "../route_tables"
  vpc_id = aws_vpc.vpc.id
  private_subnet_ids = module.private_subnets.subnets[*].id
  public_subnet_ids = module.public_subnets.subnets[*].id
  nat_id = aws_nat_gateway.nat.id
  igw_id = aws_internet_gateway.igw.id
  default_tags = var.default_tags
}

# Security Groups
module "security_groups" {
  source = "../security_groups"
  vpc_id = aws_vpc.vpc.id
  default_tags = var.default_tags
}

# Bastion
resource "aws_instance" "bastion" {
  ami = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = module.public_subnets.subnets[0].id
  security_groups = [
    module.security_groups.ssh_sg.id
  ]
  associate_public_ip_address = true
  tags = merge(var.default_tags, tomap({
    Name = "L4 Bastion"
  }))
}

module "l3_load_balancing" {
  source = "../load_balancing"
  vpc_id = aws_vpc.vpc.id
  alb_sg_ids = [
    module.security_groups.http_sg.id
  ]
  alb_subnet_ids = var.alb_subnet_ids
  key_name = var.key_name
  launch_template_sg_ids = [
    module.security_groups.ssh_sg.id,
    module.security_groups.http_sg.id
  ]
  private_subnet_ids = module.private_subnets.subnets[*].id
  default_tags       = var.default_tags
}