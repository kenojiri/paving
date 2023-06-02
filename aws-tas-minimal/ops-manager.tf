resource "aws_eip" "ops-manager" {
  vpc = true

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-ops-manager-eip" },
  )
}

resource "tls_private_key" "ops-manager" {
  count = var.ec2_ssh_key_pair_name == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "ops-manager" {
  count = var.ec2_ssh_key_pair_name == "" ? 1 : 0
  key_name = "${var.environment_name}-ops-manager-key"
  public_key = tls_private_key.ops-manager.public_key_openssh
}
