locals {
  config = {
    region = var.region
    key_pair_name = var.ec2_ssh_key_pair_name
    jumphost_private_ip = aws_network_interface.jumphost.private_ips[0]
    iam_instance_profile_name = aws_iam_instance_profile.jumphost.name
  }
}
output "config" {
  value     = jsonencode(local.config)
}
