resource "tls_private_key" "private_key" {
  count = var.letsencrypt_email_address == "" ? 0 : 1
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  count = var.letsencrypt_email_address == "" ? 0 : 1
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address = var.letsencrypt_email_address
}

resource "acme_certificate" "certificate" {
  count = var.letsencrypt_email_address == "" ? 0 : 1
  account_key_pem = acme_registration.reg.account_key_pem
  common_name = "${var.environment_name}.${var.base_domain}"
  subject_alternative_names = ["*.${var.environment_name}.${var.base_domain}", "*.sys.${var.environment_name}.${var.base_domain}", "*.apps.${var.environment_name}.${var.base_domain}"]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_API_EMAIL = var.letsencrypt_email_address
      CF_API_KEY = var.cloudflare_api_key
    }
  }
}