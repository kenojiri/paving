## inputs
## - environment_name

resource "aws_security_group" "plane" {
  provider = aws.target
  name   = "${var.environment_name}-plane-sg"
  vpc_id = data.aws_vpc.foundation.id

  ingress {
    cidr_blocks = [data.aws_vpc.foundation.cidr_block]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    cidr_blocks = [data.aws_vpc.platform_management.cidr_block]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = { "Name" = "${var.environment_name}-plane-sg" }
}

resource "aws_security_group" "opsman" {
  provider = aws.target
  name   = "${var.environment_name}-opsman-sg"
  vpc_id = data.aws_vpc.foundation.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = { "Name" = "${var.environment_name}-opsman-sg" }
}

resource "aws_security_group" "web_lb" {
  provider = aws.target
  name   = "${var.environment_name}-web-lb-sg"
  vpc_id = data.aws_vpc.foundation.id

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 4443
    to_port     = 4443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = { "Name" = "${var.environment_name}-web-lb-sg" }
}

resource "aws_security_group" "tas_router" {
  provider = aws.target
  name   = "${var.environment_name}-tas-router-sg"
  vpc_id = data.aws_vpc.foundation.id

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = { "Name" = "${var.environment_name}-tas-router-sg" }
}

resource "aws_security_group" "tas_sshproxy" {
  provider = aws.target
  name   = "${var.environment_name}-tas-sshproxy-sg"
  vpc_id = data.aws_vpc.foundation.id

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 2222
    to_port     = 2222
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = { "Name" = "${var.environment_name}-tas-sshproxy-sg" }
}

resource "aws_security_group" "tas_tcprouter" {
  provider = aws.target
  name   = "${var.environment_name}-tas-tcprouter-sg"
  vpc_id = data.aws_vpc.foundation.id

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 26770
    to_port     = 26809
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 15692
    to_port     = 15692
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16","100.99.0.0/16"]
    protocol    = "tcp"
    from_port   = 1024
    to_port     = 1024
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = { "Name" = "${var.environment_name}-tas-tcprouter-sg" }
}

resource "aws_security_group" "mysql" {
  provider = aws.target
  name   = "${var.environment_name}-mysql-sg"
  vpc_id = data.aws_vpc.foundation.id

  ingress {
    cidr_blocks = [data.aws_vpc.foundation.cidr_block]
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
  }

  egress {
    cidr_blocks = [data.aws_vpc.foundation.cidr_block]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = { "Name" = "${var.environment_name}-mysql-sg" }
}

## outputs
## - opsman_security_group_ids = [ aws_security_group.plane.id, aws_security_group.opsman.id ]
## - tas_router_security_group_ids = [ aws_security_group.tas_router.id, aws_security_group.plane.id]
## - tas_sshproxy_security_group_ids = [ aws_security_group.tas_sshproxy.id, aws_security_group.plane.id]
## - tas_tcprouter_security_group_ids = [ aws_security_group.tas_tcprouter.id, aws_security_group.plane.id]
