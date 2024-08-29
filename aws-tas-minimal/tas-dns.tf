resource "aws_route53_record" "wildcard-sys" {
  name = "*.sys.${var.environment_name}.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard-apps" {
  name = "*.apps.${var.environment_name}.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ssh" {
  name = "ssh.sys.${var.environment_name}.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard-login-sys" {
  name = "*.login.sys.${var.environment_name}.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard-uaa-sys" {
  name = "*.uaa.sys.${var.environment_name}.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "root" {
  name = "${var.environment_name}.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.zone_id
  type = "A"
  alias {
    name = aws_lb.tas.dns_name
    zone_id = aws_lb.tas.zone_id
    evaluate_target_health = true
  }
}
