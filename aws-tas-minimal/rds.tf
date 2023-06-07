resource "random_id" "db_passwd" {
  byte_length = 8
  prefix = "paving"
}

resource "aws_db_subnet_group" "tas" {
  count = var.use_rds == true ? 1 : 0
  name       = "${var.environment_name}-rds-subnet-group"
  subnet_ids = [aws_subnet.private-subnet.id, aws_subnet.secondary-private-subnet[0].id]

  tags = {
    Name = "${var.environment_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "tas" {
  count = var.use_rds == true ? 1 : 0
  allocated_storage = 20 # GiB
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.small"
  username = var.db_username
  password = "${random_id.db_passwd.id}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  availability_zone = var.availability_zone
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name = aws_db_subnet_group.tas[0].name
  identifier_prefix = "${var.environment_name}-rds-"

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-rds" },
  )
}

provider "curl" {}

data "curl" "rds_ca_cert" {
  count = var.use_rds == true ? 1 : 0
  http_method = "GET"
  uri = "https://truststore.pki.rds.amazonaws.com/${var.region}/${var.region}-bundle.pem"
}