# Create route table for each subnets
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = merge(var.default_tags, tomap({
    Name = "Public Route Table"
  }))
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }
  tags = merge(var.default_tags, tomap({
    Name = "Private Route Table"
  }))
}

# Associate route tables to subnets
resource "aws_route_table_association" "public_rt" {
  count = length(var.public_subnet_ids)
  route_table_id = aws_route_table.public_rt.id
  subnet_id = var.public_subnet_ids[count.index]
}

resource "aws_route_table_association" "private_rt" {
  count = length(var.private_subnet_ids)
  route_table_id = aws_route_table.private_rt.id
  subnet_id = var.private_subnet_ids[count.index]
}