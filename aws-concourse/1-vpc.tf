## inputs
## - vpc_name
## - subnet_names

data "aws_vpc" "concourse" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "concourse" {
  for_each = toset(var.subnet_names)
  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

## outputs
## - opsman_subnet_id = data.aws_subnet.concourse[0].id
## - opsman_private_ip = "${cidrhost(data.aws_subnet.concourse[0].cidr_block, 10)}"
## - plane_subnet_ids = data.aws_subnet.concourse[*].id
## - plane_subnet_cidrs = data.aws_subnet.concourse[*].cidr_block
## - plane_availability_zones = data.aws_subnet.concourse[*].availability_zone
