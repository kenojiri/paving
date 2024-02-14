locals {
  config = {
    opsman_subnet_id = data.aws_subnet.a.id
    opsman_private_ip = "${cidrhost(data.aws_subnet.a.cidr_block, 10)}"
    opsman_security_group_ids = [ aws_security_group.plane.id, aws_security_group.opsman.id ]
    plane_subnet_ids = var.subnet_ids
    plane_subnet_cidrs = [data.aws_subnet.a.cidr_block,data.aws_subnet.b.cidr_block,data.aws_subnet.c.cidr_block]
    plane_availability_zones = [data.aws_subnet.a.availability_zone,data.aws_subnet.b.availability_zone,data.aws_subnet.c.availability_zone]
    bosh_security_group_id = aws_security_group.plane.id

    db_endpoint = aws_db_instance.rds.endpoint
    db_username = var.db_username
    db_password = aws_db_instance.rds.password
    db_ca_cert = data.curl.rds_ca_cert.response
    db_ca_cert_id = aws_db_instance.rds.ca_cert_identifier

    tas_router_security_group_ids = [ aws_security_group.tas_router.id, aws_security_group.plane.id]
    tas_sshproxy_security_group_ids = [ aws_security_group.tas_sshproxy.id, aws_security_group.plane.id]
    tas_tcprouter_security_group_ids = [ aws_security_group.tas_tcprouter.id, aws_security_group.plane.id]
    #tas_lb_external_fqdn = aws_lb.tas.dns_name
    #tas_router_https_target_group_name = aws_lb_target_group.web-443.name
    #tas_router_http_target_group_name = aws_lb_target_group.web-80.name
    #tas_sshproxy_target_group_name = aws_lb_target_group.ssh-2222.name
    #tas_tcp_target_group_names = aws_lb_target_group.tcprouter[*].name
  }
}

output "config" {
  value     = jsonencode(local.config)
  sensitive = true
}
