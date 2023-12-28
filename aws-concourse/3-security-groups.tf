resource "aws_security_group" "plane" {
  name   = "${var.environment_name}-plane-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    cidr_blocks = [data.aws_vpc.default.cidr_block]
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

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-plane-sg" },
  )
}

resource "aws_security_group" "opsman" {
  name   = "${var.environment_name}-opsman-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    cidr_blocks = var.opsman_allowed_cidrs
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  ingress {
    cidr_blocks = var.opsman_allowed_cidrs
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  ingress {
    cidr_blocks = var.opsman_allowed_cidrs
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

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-opsman-sg" },
  )
}

resource "aws_security_group" "concourse" {
  name   = "${var.environment_name}-concourse-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
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

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-concourse-sg" },
  )
}

resource "aws_security_group" "pgsql" {
  name   = "${var.environment_name}-pgsql-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
  }

  egress {
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-pgsql-sg" },
  )
}
