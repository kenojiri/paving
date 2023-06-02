resource "aws_route53_zone" "zone" {
  count = var.cloudflare_api_key == "" ? 1 : 0
  name = var.base_domain
}

resource "aws_route53_record" "ops-manager" {
  count = var.cloudflare_api_key == "" ? 1 : 0
  name = "opsman.${var.environment_name}.${data.aws_route53_zone.zone.name}"
  zone_id = data.aws_route53_zone.zone.zone_id
  type = "A"
  ttl = 60
  records = [aws_eip.ops-manager.public_ip]
}

resource "cloudflare_record" "ops-manager" {
  count = var.cloudflare_api_key == "" ? 0 : 1
  zone_id = var.cloudflare_zone_id
  name = "opsman.${var.environment_name}"
  value = aws_eip.ops-manager.public_ip
  type = "A"
  ttl = 60
  proxied = false
}
