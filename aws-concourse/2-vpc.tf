data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = var.primary_availability_zone
  default_for_az = true
}

data "aws_subnet" "public-2" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = var.secondary_availability_zone
  default_for_az = true
}

resource "aws_subnet" "private" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = var.primary_availability_zone
  cidr_block = var.primary_private_subnet_cidr
  tags = merge(
    var.tags,
    { Name = "${var.environment_name}-primary-private-subnet" }
  )
}

resource "aws_subnet" "private-2" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = var.secondary_availability_zone
  cidr_block = var.secondary_private_subnet_cidr
  tags = merge(
    var.tags,
    { Name = "${var.environment_name}-secondary-private-subnet" }
  )
}

resource "aws_eip" "nat" {
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-nat-eip" },
  )
}

resource "aws_nat_gateway" "nat" {
  connectivity_type = "public"
  allocation_id = aws_eip.nat.id
  subnet_id     = data.aws_subnet.public.id
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-nat-gw" },
  )
}

resource "aws_route_table" "deployment" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_route" "nat-gateway-route" {
  route_table_id = aws_route_table.deployment.id
  nat_gateway_id = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "route-private-subnet" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.deployment.id
}

resource "aws_route_table_association" "route-secondary-private-subnet" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.deployment.id
}
