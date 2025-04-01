resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "app-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = zipmap(var.availability_zones,var.public_subnet_cidr)
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = zipmap(var.availability_zones,var.private_subnet_cidr)
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = false
  tags = {
    Name = "Private_Subnet${each.key}"
  }
}

resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_default_route_table" "app_default_rt" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }
  tags = {
    Name = "app-rt"
  }
}