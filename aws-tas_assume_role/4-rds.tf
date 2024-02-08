## inputs
## - environment_name
## - db_username
## - db_storage_in_gib
## - db_instance_class

resource "random_id" "db_passwd" {
  byte_length = 8
  prefix = "paving"
}

resource "aws_db_subnet_group" "rds" {
  provider = aws.target
  name       = "${var.environment_name}-rds-subnet-group"
  subnet_ids = var.elb_subnet_ids
  tags = {
    Name = "${var.environment_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  provider = aws.target
  identifier_prefix = "${var.environment_name}-rds-"
  allocated_storage = var.db_storage_in_gib
  storage_type = "gp3"
  engine = "mysql"
  engine_version = "5.7"
  parameter_group_name = "default.mysql5.7"
  instance_class = var.db_instance_class
  username = var.db_username
  password = "${random_id.db_passwd.id}"
  backup_retention_period = 0
  multi_az = true
  blue_green_update { enabled = true }
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name = aws_db_subnet_group.rds.name
  tags = { "Name" = "${var.environment_name}-rds" }
}

provider "curl" {}

data "curl" "rds_ca_cert" {
  http_method = "GET"
  uri = "https://truststore.pki.rds.amazonaws.com/${var.region}/${var.region}-bundle.pem"
}

## outputs
## - db_endpoint = aws_db_instance.rds.endpoint
## - db_username = var.db_username
## - db_password = aws_db_instance.rds.password
## - db_ca_cert = data.curl.rds_ca_cert.response
## - db_ca_cert_id = aws_db_instance.rds.ca_cert_identifier
