data "aws_route53_zone" "hosted" {
  name = "${var.base_domain}"
}

resource "aws_eip" "opsman" {
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-opsman-eip" },
  )
}

resource "aws_route53_record" "opsman" {
  zone_id = data.aws_route53_zone.hosted.zone_id
  name = "opsman.${var.environment_name}.${data.aws_route53_zone.hosted.name}"
  records = [aws_eip.opsman.public_ip]
  type    = "A"
  ttl     = 60
}

resource "aws_route53_record" "concourse" {
  zone_id = data.aws_route53_zone.hosted.zone_id
  name = "concourse.${var.environment_name}.${data.aws_route53_zone.hosted.name}"
  records = [aws_lb.concourse.dns_name]
  type    = "CNAME"
  ttl     = 60
}
