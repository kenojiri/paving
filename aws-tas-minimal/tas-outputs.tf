locals {
  stable_config_tas = {
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

    sys_dns_domain = var.cloudflare_api_key == "" ? replace(aws_route53_record.wildcard-sys[0].name, "*.", "") : "sys.${var.environment_name}.${var.base_domain}"
    apps_dns_domain =  var.cloudflare_api_key == "" ? replace(aws_route53_record.wildcard-apps[0].name, "*.", "") : "apps.${var.environment_name}.${var.base_domain}"
    ssh_dns = var.cloudflare_api_key == "" ? aws_route53_record.ssh[0].name : "ssh.${var.environment_name}.${var.base_domain}"

    db_endpoint = var.use_rds == true ? aws_db_instance.tas[0].endpoint : ""
    db_username = var.use_rds == true ? aws_db_instance.tas[0].username : ""
    db_password = var.use_rds == true ? aws_db_instance.tas[0].password : ""
    # db_name_account = var.use_rds == true ? mysql_database.account[0].name : ""
    # db_name_app_usage_service = var.use_rds == true ? mysql_database.app_usage_service[0].name : ""
    # db_name_autoscale = var.use_rds == true ? mysql_database.autoscale[0].name : ""
    # db_name_ccdb = var.use_rds == true ? mysql_database.ccdb[0].name : ""
    # db_name_credhub = var.use_rds == true ? mysql_database.credhub[0].name : ""
    # db_name_diego = var.use_rds == true ? mysql_database.diego[0].name : ""
    # db_name_locket = var.use_rds == true ? mysql_database.locket[0].name : ""
    # db_name_networkpolicyserver = var.use_rds == true ? mysql_database.networkpolicyserver[0].name : ""
    # db_name_nfsvolume = var.use_rds == true ? mysql_database.nfsvolume[0].name : ""
    # db_name_notifications = var.use_rds == true ? mysql_database.notifications[0].name : ""
    # db_name_routing = var.use_rds == true ? mysql_database.routing[0].name : ""
    # db_name_silk = var.use_rds == true ? mysql_database.silk[0].name : ""
    # db_name_uaa = var.use_rds == true ? mysql_database.uaa[0].name : ""
  }
}

output "stable_config_tas" {
  value = jsonencode(local.stable_config_tas)
  sensitive = true
}
