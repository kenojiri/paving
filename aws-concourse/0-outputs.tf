locals {
  config_opsman = {
    region = var.region
    instance_type = var.opsman_instance_type
    boot_disk_size = var.opsman_boot_disk_size_in_gb
    key_pair_name = var.ec2_ssh_key_pair_name
    iam_instance_profile_name = aws_iam_instance_profile.opsman.name
    security_group_ids = [ aws_security_group.plane.id, aws_security_group.opsman.id ]
    plane_security_group_id = aws_security_group.plane.id
    opsman_security_group_id = aws_security_group.opsman.id
    vpc_subnet_id = data.aws_subnet.public.id
    public_ip = aws_eip.opsman.public_ip
    vm_name = "opsman"
    opsman_fqdn = aws_route53_record.opsman.name
    opsman_ssl_certificate = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    opsman_ssl_privatekey = acme_certificate.certificate.private_key_pem
  }
}
locals {
  config_bosh = {
    iam_instance_profile_name = aws_iam_instance_profile.opsman.name
    security_group_id = aws_security_group.plane.id
    key_pair_name = var.ec2_ssh_key_pair_name
    region = var.region
    blobstore_s3_endpoint = "http://s3.amazonaws.com/"
    blobstore_s3_bucket_name = aws_s3_bucket.bosh.bucket
    blobstore_s3_access_key = var.access_key_id
    blobstore_s3_secret_key = var.secret_access_key
    availability_zones = [ var.primary_availability_zone, var.secondary_availability_zone ]
    public_primary_subnet_id = data.aws_subnet.public.id
    public_primary_subnet_cidr = data.aws_subnet.public.cidr_block
    public_primary_subnet_reserved_ip_ranges = "${cidrhost(data.aws_subnet.public.cidr_block, 1)}-${cidrhost(data.aws_subnet.public.cidr_block, 9)}"
    public_primary_subnet_gateway = cidrhost(data.aws_subnet.public.cidr_block, 1)
    public_secondary_subnet_id = data.aws_subnet.public-2.id
    public_secondary_subnet_cidr = data.aws_subnet.public-2.cidr_block
    public_secondary_subnet_reserved_ip_ranges = "${cidrhost(data.aws_subnet.public-2.cidr_block, 1)}-${cidrhost(data.aws_subnet.public-2.cidr_block, 9)}"
    public_secondary_subnet_gateway = cidrhost(data.aws_subnet.public-2.cidr_block, 1)
    private_primary_subnet_id = aws_subnet.private.id
    private_primary_subnet_cidr = aws_subnet.private.cidr_block
    private_primary_subnet_reserved_ip_ranges = "${cidrhost(aws_subnet.private.cidr_block, 1)}-${cidrhost(aws_subnet.private.cidr_block, 9)}"
    private_primary_subnet_gateway = cidrhost(aws_subnet.private.cidr_block, 1)
    private_secondary_subnet_id = aws_subnet.private-2.id
    private_secondary_subnet_cidr = aws_subnet.private-2.cidr_block
    private_secondary_subnet_reserved_ip_ranges = "${cidrhost(aws_subnet.private-2.cidr_block, 1)}-${cidrhost(aws_subnet.private-2.cidr_block, 9)}"
    private_secondary_subnet_gateway = cidrhost(aws_subnet.private-2.cidr_block, 1)
  }
}
locals {
  config_concourse = {
    concourse_fqdn = aws_route53_record.concourse.name
    plane_security_group_id = aws_security_group.plane.id
    availability_zones = [ var.primary_availability_zone, var.secondary_availability_zone ]
    concourse_web_security_group_id = aws_security_group.concourse.id
    concourse_worker_security_group_ids = [ aws_security_group.plane.id ]
    concourse_lb_web_target_group_name = aws_lb_target_group.web-443.name
    concourse_lb_tcp_target_group_name = aws_lb_target_group.tcp-2222.name
    ssl_certificate = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    ssl_private_key = acme_certificate.certificate.private_key_pem
    db_endpoint = var.use_rds == true ? aws_db_instance.rds[0].endpoint : ""
    db_username = var.use_rds == true ? var.db_username : ""
    db_password = var.use_rds == true ? aws_db_instance.rds[0].password : ""
    db_ca_cert = var.use_rds == true ? data.curl.rds_ca_cert[0].response : ""
    db_ca_cert_id = var.use_rds == true ? aws_db_instance.rds[0].ca_cert_identifier : ""
    aws_asm_region = var.region
    iam_instance_profile_name = aws_iam_instance_profile.opsman.name
  }
}

output "config_opsman" {
  value     = jsonencode(local.config_opsman)
  sensitive = true
}
output "config_bosh" {
  value     = jsonencode(local.config_bosh)
  sensitive = true
}
output "config_concourse" {
  value     = jsonencode(local.config_concourse)
  sensitive = true
}
