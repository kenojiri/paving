locals {
  config = {
    opsman_subnet_id = data.aws_subnet.concourse[0].id
    opsman_private_ip = "${cidrhost(data.aws_subnet.concourse[0].cidr_block, 10)}"
    opsman_security_group_ids = [ aws_security_group.plane.id, aws_security_group.opsman.id ]
    plane_subnet_ids = data.aws_subnet.concourse[*].id
    plane_subnet_cidrs = data.aws_subnet.concourse[*].cidr_block
    plane_availability_zones = data.aws_subnet.concourse[*].availability_zone
    bosh_security_group_id = aws_security_group.plane.id
    concourse_web_security_group_ids = [ aws_security_group.concourse.id, aws_security_group.plane.id]
    concourse_worker_security_group_ids = [ aws_security_group.plane.id ]
    concourse_lb_external_fqdn = aws_lb.concourse.dns_name
    concourse_lb_web_target_group_name = aws_lb_target_group.web-443.name
    concourse_lb_tcp_target_group_name = aws_lb_target_group.tcp-2222.name
    concourse_db_endpoint = aws_db_instance.rds.endpoint
    concourse_db_username = var.db_username
    concourse_db_password = aws_db_instance.rds.password
    concourse_db_ca_cert = data.curl.rds_ca_cert.response
    concourse_db_ca_cert_id = aws_db_instance.rds[0].ca_cert_identifier
  }
}

output "config" {
  value     = jsonencode(local.config)
  sensitive = true
}
