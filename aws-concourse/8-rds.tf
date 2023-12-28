resource "random_id" "db_passwd" {
  byte_length = 8
  prefix = "paving"
}

resource "aws_db_subnet_group" "rds" {
  count = var.use_rds == true ? 1 : 0
  name       = "${var.environment_name}-rds-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private-2.id]
  tags = {
    Name = "${var.environment_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  count = var.use_rds == true ? 1 : 0
  identifier_prefix = "${var.environment_name}-rds-"
  allocated_storage = 20 # GiB
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "11.22"
  instance_class = "db.m4.large"
  username = var.db_username
  password = "${random_id.db_passwd.id}"
  backup_retention_period = 0
  multi_az = true
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.pgsql.id]
  db_subnet_group_name = aws_db_subnet_group.rds[0].name
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
