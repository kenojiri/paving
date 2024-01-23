resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "${var.environment_name}-vpc" }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block = element(var.private_subnet_cidrs, count.index)
  tags = { Name = "${var.environment_name}-private-subnet-${count.index}" }
}
