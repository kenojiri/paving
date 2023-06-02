resource "aws_route53_record" "wildcard-sys" {
  count = var.cloudflare_api_key == "" ? 1 : 0
  name = "*.sys.${var.environment_name}.${data.aws_route53_zone.zone.name}"
  zone_id = data.aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard-apps" {
  count = var.cloudflare_api_key == "" ? 1 : 0
  name = "*.apps.${var.environment_name}.${data.aws_route53_zone.zone.name}"
  zone_id = data.aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ssh" {
  count = var.cloudflare_api_key == "" ? 1 : 0
  name = "ssh.sys.${var.environment_name}.${data.aws_route53_zone.hosted.name}"
  zone_id = data.aws_route53_zone.hosted.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "cloudflare_record" "wildcard-sys" {
  count = var.cloudflare_api_key == "" ? 0 : 1
  zone_id = var.cloudflare_zone_id
  name = "*.sys.${var.environment_name}"
  value = aws_lb.tas.dns_name
  type = "CNAME"
  ttl = 60
  proxied = false
}

resource "cloudflare_record" "wildcard-apps" {
  count = var.cloudflare_api_key == "" ? 0 : 1
  zone_id = var.cloudflare_zone_id
  name = "*.apps.${var.environment_name}"
  value = aws_lb.tas.dns_name
  type = "CNAME"
  ttl = 60
  proxied = false
}

resource "cloudflare_record" "ssh" {
  count = var.cloudflare_api_key == "" ? 0 : 1
  zone_id = var.cloudflare_zone_id
  name = "ssh.${var.environment_name}"
  value = aws_lb.tas.dns_name
  type = "CNAME"
  ttl = 60
  proxied = false
}
