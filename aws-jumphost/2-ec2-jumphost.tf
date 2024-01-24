## inputs
## - jumphost_vpc_name
## - jumphost_subnet_name
## - ec2_ssh_key_pair_name

data "aws_vpc" "jumphost" {
  filter {
    name   = "tag:Name"
    values = [var.jumphost_vpc_name]
  }
}

data "aws_subnet" "jumphost" {
  filter {
    name   = "tag:Name"
    values = [var.jumphost_subnet_name]
  }
}

resource "aws_security_group" "jumphost" {
  name   = "jumphost-sg"
  vpc_id = data.aws_vpc.jumphost.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_network_interface" "jumphost" {
  subnet_id = data.aws_subnet.jumphost.id
  security_groups = [aws_security_group.jumphost.id]
}

resource "aws_instance" "jumphost" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = var.ec2_ssh_key_pair_name
  root_block_device {
    volume_size = 30 #GiB
  }
  network_interface {
    network_interface_id = aws_network_interface.jumphost.id
    device_index = 0
  }
  iam_instance_profile = aws_iam_instance_profile.jumphost.name

  tags = {
    Name = "jumphost"
  }
}

## outputs
## - jumphost_private_ip = aws_network_interface.jumphost.private_ips[0]
