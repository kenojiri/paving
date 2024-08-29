resource "aws_route53_zone" "zone" {
  name = var.base_domain
}

resource "aws_route53_record" "ops-manager" {
  name = "opsman.${var.environment_name}.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.zone_id
  type = "A"
  ttl = 60
  records = [aws_eip.ops-manager.public_ip]
}
