resource "random_id" "db_passwd" {
  byte_length = 8
  prefix      = "VMware1!"
}

resource "aws_db_instance" "tas" {
  allocated_storage = 20 # GiB
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.small"
  username = var.db_username
  password = "${random_id.db_passwd.b64}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  availability_zone = var.availability_zone
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_name = "bosh"
}

provider "mysql" {
  endpoint = "${aws_db_instance.tas.endpoint}"
  username = "${aws_db_instance.tas.username}"
  password = "${aws_db_instance.tas.password}"
}

resource "mysql_database" "account" {
  name = "account"
}

resource "mysql_database" "app_usage_service" {
  name = "app_usage_service"
}

resource "mysql_database" "autoscale" {
  name = "autoscale"
}

resource "mysql_database" "ccdb" {
  name = "ccdb"
}

resource "mysql_database" "credhub" {
  name = "credhub"
}

resource "mysql_database" "diego" {
  name = "diego"
}

resource "mysql_database" "locket" {
  name = "locket"
}

resource "mysql_database" "networkpolicyserver" {
  name = "networkpolicyserver"
}

resource "mysql_database" "nfsvolume" {
  name = "nfsvolume"
}

resource "mysql_database" "notifications" {
  name = "notifications"
}

resource "mysql_database" "routing" {
  name = "routing"
}

resource "mysql_database" "silk" {
  name = "silk"
}

resource "mysql_database" "uaa" {
  name = "uaa"
}
