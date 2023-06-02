locals {
  stable_config_opsmanager = {
    access_key = var.access_key
    secret_key = var.secret_key
    environment_name = var.environment_name
    availability_zones = var.availability_zone
    region = var.region

    vpc_id = aws_vpc.vpc.id

    public_subnet_id = aws_subnet.public-subnet.id
    public_subnet_cidr = aws_subnet.public-subnet.cidr_block
    private_subnet_id = aws_subnet.private-subnet.id
    private_subnet_cidr = aws_subnet.private-subnet.cidr_block
    private_subnet_gateway = cidrhost(aws_subnet.private-subnet.cidr_block, 1)
    private_subnet_reserved_ip_ranges = "${cidrhost(aws_subnet.private-subnet.cidr_block, 1)}-${cidrhost(aws_subnet.private-subnet.cidr_block, 9)}"

    platform_vms_security_group_id   = aws_security_group.platform.id
    platform_vms_security_group_name = aws_security_group.platform.name
    nat_security_group_id   = aws_security_group.nat.id
    nat_security_group_name = aws_security_group.nat.name

    ops_manager_subnet_id = aws_subnet.public-subnet.id
    ops_manager_public_ip = aws_eip.ops-manager.public_ip
    ops_manager_dns = var.cloudflare_api_token == "" ? aws_route53_record.ops-manager.name : "opsman.${var.environment_name}.${var.base_domain}"
    ops_manager_iam_user_access_key = aws_iam_access_key.ops-manager.id
    ops_manager_iam_user_secret_key = aws_iam_access_key.ops-manager.secret
    ops_manager_iam_instance_profile_name = aws_iam_instance_profile.ops-manager.name
    ops_manager_key_pair_name = var.ec2_ssh_key_pair_name == "" ? aws_key_pair.ops-manager.key_name : var.ec2_ssh_key_pair_name
    ops_manager_ssh_public_key = var.ec2_ssh_key_pair_name == "" ? tls_private_key.ops-manager.public_key_openssh : ""
    ops_manager_ssh_private_key = var.ec2_ssh_key_pair_name == "" ? tls_private_key.ops-manager.private_key_pem : ""
    ops_manager_bucket = aws_s3_bucket.ops-manager-bucket.bucket
    ops_manager_security_group_id         = aws_security_group.ops-manager.id
    ops_manager_security_group_name       = aws_security_group.ops-manager.name

    ssl_certificate = var.letsencrypt_email_address == "" ? var.ssl_certificate : acme_certificate.certificate.certificate_pem
    ssl_private_key = var.letsencrypt_email_address == "" ? var.ssl_private_key : acme_certificate.certificate.private_key_pem
  }
}

output "stable_config_opsmanager" {
  value     = jsonencode(local.stable_config_opsmanager)
  sensitive = true
}
