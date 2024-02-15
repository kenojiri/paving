## inputs
## - vpc_name
## - subnet_ids
## - elb_subnet_ids

data "aws_vpc" "foundation" {
  provider = aws.target
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_vpc" "platform_management" {
  provider = aws.base
  filter {
    name   = "tag:Name"
    values = [var.platform_management_vpc_name]
  }
}

data "aws_subnet" "a" {
  provider = aws.target
  id = var.subnet_ids[0]
}
data "aws_subnet" "b" {
  provider = aws.target
  id = var.subnet_ids[1]
}
data "aws_subnet" "c" {
  provider = aws.target
  id = var.subnet_ids[2]
}

data "aws_subnet" "elb-a" {
  provider = aws.target
  id = var.elb_subnet_ids[0]
}
data "aws_subnet" "elb-b" {
  provider = aws.target
  id = var.elb_subnet_ids[1]
}
data "aws_subnet" "elb-c" {
  provider = aws.target
  id = var.elb_subnet_ids[2]
}

## outputs
## - opsman_subnet_id = data.aws_subnet.a.id
## - opsman_private_ip = "${cidrhost(data.aws_subnet.a.cidr_block, 10)}"
## - plane_subnet_cidrs = [data.aws_subnet.a.cidr_block.data.aws_subnet.b.cidr_block,data.aws_subnet.c.cidr_block]
## - plane_availability_zones = [data.aws_subnet.a.availability_zone,data.aws_subnet.b.availability_zone,data.aws_subnet.c.availability_zone]
