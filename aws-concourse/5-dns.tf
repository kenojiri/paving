data "aws_route53_zone" "hosted" {
  name = "${var.environment_name}.${var.base_domain}"
}

#resource "aws_route53_record" "opsman" {
#  zone_id = data.aws_route53_zone.hosted.zone_id
#  name = "opsman.${data.aws_route53_zone.hosted.name}"
#  records = [****]
#  type    = "A"
#  ttl     = 60
#}

resource "aws_route53_record" "concourse" {
  zone_id = data.aws_route53_zone.hosted.zone_id
  name = "concourse.${data.aws_route53_zone.hosted.name}"
  records = [aws_lb.concourse.dns_name]
  type    = "CNAME"
  ttl     = 60
}
