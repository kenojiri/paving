locals {
  stable_config_tas = {
    buildpacks_bucket_name = aws_s3_bucket.buildpacks-bucket.bucket
    droplets_bucket_name = aws_s3_bucket.droplets-bucket.bucket
    packages_bucket_name = aws_s3_bucket.packages-bucket.bucket
    resources_bucket_name = aws_s3_bucket.resources-bucket.bucket
    tas_blobstore_iam_instance_profile_name = aws_iam_instance_profile.tas-blobstore.name

    platform_vms_security_group_id   = aws_security_group.platform.id
    platform_vms_security_group_name = aws_security_group.platform.name
    web_lb_security_group_id = aws_security_group.web-lb.id
    web_lb_security_group_name = aws_security_group.web-lb.name
    web_target_group_names = [
      aws_lb_target_group.web-80.name,
      aws_lb_target_group.web-443.name]
    ssh_lb_security_group_id = aws_security_group.ssh-lb.id
    ssh_lb_security_group_name = aws_security_group.ssh-lb.name
    ssh_target_group_name = aws_lb_target_group.ssh-2222.name

    sys_dns_domain = var.cloudflare_api_key == "" ? replace(aws_route53_record.wildcard-sys[0].name, "*.", "") : "sys.${var.environment_name}.${var.base_domain}"
    apps_dns_domain =  var.cloudflare_api_key == "" ? replace(aws_route53_record.wildcard-apps[0].name, "*.", "") : "apps.${var.environment_name}.${var.base_domain}"
    ssh_dns = var.cloudflare_api_key == "" ? aws_route53_record.ssh[0].name : "ssh.${var.environment_name}.${var.base_domain}"

    db_endpoint = var.use_rds == true ? aws_db_instance.tas[0].endpoint : ""
    db_username = var.use_rds == true ? aws_db_instance.tas[0].username : ""
    db_password = var.use_rds == true ? aws_db_instance.tas[0].password : ""
    db_ca_cert_id = var.use_rds == true ? aws_db_instance.tas[0].ca_cert_identifier : ""
    db_ca_cert = var.use_rds == true ? data.curl.rds_ca_cert[0].response : ""

    ssl_certificate = var.ssl_certificate == "" ? "${acme_certificate.certificate[0].certificate_pem}\n${acme_certificate.certificate[0].issuer_pem}" : var.ssl_certificate
    ssl_private_key = var.ssl_certificate == "" ? acme_certificate.certificate[0].private_key_pem : var.ssl_private_key
  }
}

output "stable_config_tas" {
  value = jsonencode(local.stable_config_tas)
  sensitive = true
}
