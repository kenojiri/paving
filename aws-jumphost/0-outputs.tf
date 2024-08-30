locals {
  config = {
    region = var.region
    key_pair_name = var.ec2_ssh_key_pair_name
    jumphost_public_ip = aws_eip.jumphost.public_ip
    iam_instance_profile_name = aws_iam_instance_profile.jumphost.name
  }
}
output "config" {
  value     = jsonencode(local.config)
}
