## inputs
## - environment_name
## - https_listener_cert_secret_arn

data "aws_secretsmanager_secret" "cert-secret" {
  arn      = var.https_listener_cert_secret_arn
}

data "aws_secretsmanager_secret_version" "cert-secret-version" {
  secret_id = data.aws_secretsmanager_secret.cert-secret.id
}

resource "aws_acm_certificate" "web_lb" {
  private_key       = jsondecode(data.aws_secretsmanager_secret_version.cert-secret-version.secret_string)["private_key"]
  certificate_body  = jsondecode(data.aws_secretsmanager_secret_version.cert-secret-version.secret_string)["certificate_body"]
  certificate_chain = jsondecode(data.aws_secretsmanager_secret_version.cert-secret-version.secret_string)["certificate_chain"]
}

resource "aws_lb" "tas_alb" {
  name = "${var.environment_name}-tas-web-lb"
  load_balancer_type = "application"
  internal = true
  enable_cross_zone_load_balancing = true
  subnets = [data.aws_subnet.elb-a.id,data.aws_subnet.elb-b.id,data.aws_subnet.elb-c.id]
  security_groups = [aws_security_group.web_lb.id]
}

resource "aws_lb_target_group" "web-443" {
  name = "${var.environment_name}-web-443-tg"
  port = 443
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "web-443" {
  load_balancer_arn = aws_lb.tas_alb.arn
  port = 443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }
}

resource "aws_lb_listener_certificate" "web-443" {
  listener_arn    = aws_lb_listener.web-443.arn
  certificate_arn = aws_acm_certificate.web_lb.arn
}

resource "aws_lb_target_group" "web-4443" {
  name = "${var.environment_name}-web-4443-tg"
  port = 4443
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "web-4443" {
  load_balancer_arn = aws_lb.tas_alb.arn
  port = 4443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-4443.arn
  }
}

resource "aws_lb_listener_certificate" "web-4443" {
  listener_arn    = aws_lb_listener.web-4443.arn
  certificate_arn = aws_acm_certificate.web_lb.arn
}

resource "aws_lb" "tas_nlb" {
  name = "${var.environment_name}-tas-tcp-lb"
  load_balancer_type = "network"
  internal = true
  enable_cross_zone_load_balancing = true
  subnets = [data.aws_subnet.elb-a.id,data.aws_subnet.elb-b.id,data.aws_subnet.elb-c.id]
}

resource "aws_lb_target_group" "ssh-2222" {
  name = "${var.environment_name}-ssh-2222-tg"
  port = 2222
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "ssh-2222" {
  load_balancer_arn = aws_lb.tas_nlb.arn
  port = 2222
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ssh-2222.arn
  }
}

resource "aws_lb_target_group" "tcp-443" {
  name = "${var.environment_name}-tcp-443-tg"
  port = 443
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "tcp-443" {
  load_balancer_arn = aws_lb.tas_nlb.arn
  port = 443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tcp-443.arn
  }
}

resource "aws_lb_target_group" "tcp-4443" {
  name = "${var.environment_name}-tcp-4443-tg"
  port = 4443
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "tcp-4443" {
  load_balancer_arn = aws_lb.tas_nlb.arn
  port = 4443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tcp-4443.arn
  }
}

resource "aws_lb_target_group" "tcp-1024" {
  name = "${var.environment_name}-tcp-1024-tg"
  port = 1024
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "tcp-1024" {
  load_balancer_arn = aws_lb.tas_nlb.arn
  port = 1024
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tcp-1024.arn
  }
}

resource "aws_lb_target_group" "tcp-15692" {
  name = "${var.environment_name}-tcp-15692-tg"
  port = 15692
  protocol = "TCP"
  vpc_id = data.aws_vpc.foundation.id
  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "tcp-15692" {
  load_balancer_arn = aws_lb.tas_nlb.arn
  port = 15692
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tcp-15692.arn
  }
}

locals {
  rabbitmq_port_count = 40
}

resource "aws_lb_target_group" "rabbitmq" {
  count = local.rabbitmq_port_count

  name     = "${var.environment_name}-rabbitmq-${26770 + count.index}-tg"
  port     = 26770 + count.index
  protocol = "TCP"
  vpc_id   = data.aws_vpc.foundation.id

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "rabbitmq" {
  load_balancer_arn = aws_lb.tas_nlb.arn
  port              = 26770 + count.index
  protocol          = "TCP"

  count = local.rabbitmq_port_count

  default_action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.rabbitmq[*].arn, count.index)
  }
}

## output
## - tas_web_lb_external_fqdn = aws_lb.tas_alb.dns_name
## - tas_tcp_lb_external_fqdn = aws_lb.tas_nlb.dns_name
## - tas_router_https_target_group_name = aws_lb_target_group.web-443.name
## - tas_router_tcp4443_target_group_name = aws_lb_target_group.web-4443.name
## - tas_sshproxy_target_group_name = aws_lb_target_group.ssh-2222.name
