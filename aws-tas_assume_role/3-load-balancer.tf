## inputs
## - environment_name
## - https_listener_cert_secret_arn

data "aws_secretsmanager_secret" "cert-secret" {
  provider = aws.base
  arn      = var.https_listener_cert_secret_arn
}

data "aws_secretsmanager_secret_version" "cert-secret-version" {
  provider = aws.base
  secret_id = data.aws_secretsmanager_secret.cert-secret.id
}

resource "aws_acm_certificate" "web_lb" {
  provider = aws.target
  private_key       = jsondecode(data.aws_secretsmanager_secret_version.cert-secret-version.secret_string)["private_key"]
  certificate_body  = jsondecode(data.aws_secretsmanager_secret_version.cert-secret-version.secret_string)["certificate_body"]
  certificate_chain = jsondecode(data.aws_secretsmanager_secret_version.cert-secret-version.secret_string)["ca_chain"]
}

resource "aws_lb" "tas_alb" {
  provider = aws.target
  name = "${var.environment_name}-tas-web-lb"
  load_balancer_type = "application"
  internal = true
  enable_cross_zone_load_balancing = true
  subnets = [data.aws_subnet.elb-a.id,data.aws_subnet.elb-b.id,data.aws_subnet.elb-c.id]
  security_groups = [aws_security_group.web_lb.id]
}

resource "aws_lb_target_group" "web-443" {
  provider = aws.target
  name = "${var.environment_name}-web-443-tg"
  port = 443
  protocol = "HTTPS"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "HTTP"
    path = "/health"
    port = 8080
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
  }
}

resource "aws_lb_listener" "web-443" {
  provider = aws.target
  load_balancer_arn = aws_lb.tas_alb.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.web_lb.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }
}

resource "aws_lb_listener" "web-4443" {
  provider = aws.target
  load_balancer_arn = aws_lb.tas_alb.arn
  port = 4443
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.web_lb.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }
}

#resource "aws_lb" "tas_nlb" {
#  provider = aws.target
#  name = "${var.environment_name}-tas-tcp-lb"
#  load_balancer_type = "network"
#  internal = true
#  enable_cross_zone_load_balancing = true
#  subnets = [data.aws_subnet.elb-a.id,data.aws_subnet.elb-b.id,data.aws_subnet.elb-c.id]
#}
#
#resource "aws_lb_target_group" "ssh-2222" {
#  provider = aws.target
#  name = "${var.environment_name}-ssh-2222-tg"
#  port = 2222
#  protocol = "TCP"
#  vpc_id = data.aws_vpc.foundation.id
#  health_check {
#    protocol = "TCP"
#    interval = 30
#    timeout = 29
#    healthy_threshold = 6
#    unhealthy_threshold = 6
#  }
#}
#
#resource "aws_lb_listener" "ssh-2222" {
#  provider = aws.target
#  load_balancer_arn = aws_lb.tas_nlb.arn
#  port = 2222
#  protocol = "TCP"
#  default_action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.ssh-2222.arn
#  }
#}
#
#resource "aws_lb_target_group" "tcp-443" {
#  provider = aws.target
#  name = "${var.environment_name}-tcp-443-tg"
#  port = 443
#  protocol = "TCP"
#  vpc_id = data.aws_vpc.foundation.id
#  health_check {
#    protocol = "TCP"
#  }
#}
#
#resource "aws_lb_listener" "tcp-443" {
#  provider = aws.target
#  load_balancer_arn = aws_lb.tas_nlb.arn
#  port = 443
#  protocol = "TCP"
#  default_action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.tcp-443.arn
#  }
#}
#
#resource "aws_lb_listener" "tcp-4443" {
#  provider = aws.target
#  load_balancer_arn = aws_lb.tas_nlb.arn
#  port = 4443
#  protocol = "TCP"
#  default_action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.tcp-443.arn
#  }
#}
#
#resource "aws_lb_target_group" "tcprouter" {
#  provider = aws.target
#  name = "${var.environment_name}-tcprouter-tg"
#  port = 1024
#  protocol = "TCP"
#  vpc_id = data.aws_vpc.foundation.id
#  health_check {
#    protocol = "HTTP"
#    path = "/health"
#    port = 80
#    healthy_threshold = 6
#    unhealthy_threshold = 6
#    timeout = 10
#    interval = 30
#  }
#}
#
#resource "aws_lb_listener" "tcp-1024" {
#  provider = aws.target
#  load_balancer_arn = aws_lb.tas_nlb.arn
#  port = 1024
#  protocol = "TCP"
#  default_action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.tcprouter.arn
#  }
#}
#
#resource "aws_lb_listener" "tcp-15692" {
#  provider = aws.target
#  load_balancer_arn = aws_lb.tas_nlb.arn
#  port = 15692
#  protocol = "TCP"
#  default_action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.tcprouter.arn
#  }
#}
#
#locals {
#  rabbitmq_port_count = 40
#}
#
#resource "aws_lb_target_group" "rabbitmq" {
#  count = local.rabbitmq_port_count
#
#  provider = aws.target
#  name     = "${var.environment_name}-rabbitmq-${26770 + count.index}-tg"
#  port     = 26770 + count.index
#  protocol = "TCP"
#  vpc_id   = data.aws_vpc.foundation.id
#
#  health_check {
#    protocol = "HTTP"
#    path = "/health"
#    port = 80
#    healthy_threshold = 6
#    unhealthy_threshold = 6
#    timeout = 10
#    interval = 30
#  }
#}
#
#resource "aws_lb_listener" "rabbitmq" {
#  provider = aws.target
#  load_balancer_arn = aws_lb.tas_nlb.arn
#  port              = 26770 + count.index
#  protocol          = "TCP"
#
#  count = local.rabbitmq_port_count
#
#  default_action {
#    type             = "forward"
#    target_group_arn = element(aws_lb_target_group.rabbitmq[*].arn, count.index)
#  }
#}

## output
## - tas_web_lb_external_fqdn = aws_lb.tas_alb.dns_name
## - tas_tcp_lb_external_fqdn = aws_lb.tas_nlb.dns_name
## - tas_router_https_target_group_name = aws_lb_target_group.web-443.name
## - tas_sshproxy_target_group_name = aws_lb_target_group.ssh-2222.name
## - tas_tcprouter_target_group_name = aws_lb_target_group.tcprouter.name
