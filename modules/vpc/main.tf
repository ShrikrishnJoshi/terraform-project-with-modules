
########################
# LOCALS (COMMON TAGS)
########################

locals {
  common_tags = {
    Environment = var.env
    Project     = "terraform-practice"
    ManagedBy   = "Terraform"
  }
}

########################
# VPC
########################

resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.env}-vpc"
  })
}

########################
# Internet Gateway
########################

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.env}-igw"
  })
}

########################
# Public Subnet
########################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.env}-public-subnet"
  })
}

########################
# Private Subnet
########################

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az

  tags = merge(local.common_tags, {
    Name = "${var.env}-private-subnet"
  })
}

########################
# Public Route Table
########################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.env}-public-rt"
  })
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

########################
# NAT Gateway + EIP
########################

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.env}-nat-eip"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.dev_igw]

  tags = merge(local.common_tags, {
    Name = "${var.env}-nat"
  })
}

########################
# Private Route Table
########################

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.env}-private-rt"
  })
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}