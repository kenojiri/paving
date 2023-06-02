locals {
  stable_config_pas = {
    buildpacks_bucket_name = aws_s3_bucket.buildpacks-bucket.bucket
    droplets_bucket_name = aws_s3_bucket.droplets-bucket.bucket
    packages_bucket_name = aws_s3_bucket.packages-bucket.bucket
    resources_bucket_name = aws_s3_bucket.resources-bucket.bucket
    tas_blobstore_iam_instance_profile_name = aws_iam_instance_profile.tas-blobstore.name

    web_lb_security_group_id = aws_security_group.web-lb.id
    web_lb_security_group_name = aws_security_group.web-lb.name
    web_target_group_names = [
      aws_lb_target_group.web-80.name,
      aws_lb_target_group.web-443.name]
    ssh_lb_security_group_id = aws_security_group.ssh-lb.id
    ssh_lb_security_group_name = aws_security_group.ssh-lb.name
    ssh_target_group_name = aws_lb_target_group.ssh-2222.name

    sys_dns_domain = var.cloudflare_api_key == "" ? replace(aws_route53_record.wildcard-sys.name, "*.", "") : "sys.${var.environment_name}.${var.base_domain}"
    apps_dns_domain =  var.cloudflare_api_key == "" ? replace(aws_route53_record.wildcard-apps.name, "*.", "") : "apps.${var.environment_name}.${var.base_domain}"
    ssh_dns = var.cloudflare_api_key == "" ? aws_route53_record.ssh.name : "ssh.${var.environment_name}.${var.base_domain}"
  }
}

output "stable_config_pas" {
  value = jsonencode(local.stable_config_pas)
  sensitive = true
}
