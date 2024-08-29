resource "tls_private_key" "private_key" {
  count = var.ssl_certificate == "" ? 1 : 0
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  count = var.ssl_certificate == "" ? 1 : 0
  account_key_pem = tls_private_key.private_key[0].private_key_pem
  email_address = var.email
}

resource "acme_certificate" "certificate" {
  count = var.ssl_certificate == "" ? 1 : 0
  account_key_pem = acme_registration.reg[0].account_key_pem
  common_name = "${var.environment_name}.${var.base_domain}"
  subject_alternative_names = ["*.${var.environment_name}.${var.base_domain}", "*.sys.${var.environment_name}.${var.base_domain}", "*.apps.${var.environment_name}.${var.base_domain}"]

  dns_challenge {
    provider = "route53"
    config = {
      AWS_DEFAULT_REGION = var.region
    }
  }
}
