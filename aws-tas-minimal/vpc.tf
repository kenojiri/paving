resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    { Name = "${var.environment_name}-vpc" },
  )
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    var.tags,
    { Name = "${var.environment_name}-public-subnet" }
  )
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    var.tags,
    { Name = "${var.environment_name}-private-subnet" }
  )
}

resource "aws_subnet" "secondary-private-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.secondary_private_subnet_cidr
  availability_zone = var.secondary_availability_zone

  tags = merge(
    var.tags,
    { Name = "${var.environment_name}-secondary-private-subnet" }
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "nat" {
  #domain = "vpc"

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-nat-eip" },
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-nat-gateway" },
  )

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "deployment" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "nat-gateway-route" {
  route_table_id = aws_route_table.deployment.id
  nat_gateway_id = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "route-private-subnet" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.deployment.id
}

resource "aws_route_table_association" "route-secondary-private-subnet" {
  subnet_id      = aws_subnet.secondary-private-subnet.id
  route_table_id = aws_route_table.deployment.id
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "route-public-subnet" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}
