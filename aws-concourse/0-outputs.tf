locals {
  config = {
    plane_subnet_ids = aws_subnet.private[*].id
    plane_subnet_cidrs = aws_subnet.private[*].cidr_block
    opsman_subnet_id = aws_subnet.private[0].id
    opsman_security_group_ids = [ aws_security_group.plane.id, aws_security_group.opsman.id ]
    opsman_private_ip = "${cidrhost(aws_subnet.private[0].cidr_block, 10)}"
    bosh_security_group_id = aws_security_group.plane.id
    bosh_bucket_name = aws_s3_bucket.bosh.bucket
    concourse_fqdn = aws_route53_record.concourse.name
    concourse_web_security_group_ids = [ aws_security_group.concourse.id, aws_security_group.plane.id]
    concourse_worker_security_group_ids = [ aws_security_group.plane.id ]
    concourse_lb_web_target_group_name = aws_lb_target_group.web-443.name
    concourse_lb_tcp_target_group_name = aws_lb_target_group.tcp-2222.name
    concourse_db_endpoint = var.use_rds == true ? aws_db_instance.rds[0].endpoint : ""
    concourse_db_username = var.use_rds == true ? var.db_username : ""
    concourse_db_password = var.use_rds == true ? aws_db_instance.rds[0].password : ""
    concourse_db_ca_cert = var.use_rds == true ? data.curl.rds_ca_cert[0].response : ""
    concourse_db_ca_cert_id = var.use_rds == true ? aws_db_instance.rds[0].ca_cert_identifier : ""
  }
}

output "config" {
  value     = jsonencode(local.config)
  sensitive = true
}
